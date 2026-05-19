#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($RealBin);
use File::Basename qw(dirname);
use File::Copy qw(copy);
use File::Path qw(make_path);
use Getopt::Long qw(GetOptions);

my %opt = (
    repo_root           => dirname($RealBin),
    include_postprocess => 0,
);

GetOptions(
    'project-dir|analysis-dir=s' => \$opt{project_dir},
    'sample-file=s' => \$opt{sample_file},
    'experiment=s'  => \$opt{experiment},
    'mail-user=s'   => \$opt{mail_user},
    'output-dir=s'  => \$opt{output_dir},
    'repo-root=s'   => \$opt{repo_root},
    'include-postprocess!' => \$opt{include_postprocess},
    'help'          => \$opt{help},
) or die usage();

if ($opt{help}) {
    print usage();
    exit 0;
}

$opt{project_dir} ||= prompt('Enter the analysis directory (project-dir): ');
$opt{sample_file} ||= prompt('Enter the sample file path: ');
$opt{experiment}  ||= prompt('Enter the experiment name: ');
if (!defined $opt{mail_user}) {
    $opt{mail_user} = (-t STDIN) ? prompt('Enter the email for Slurm notifications (optional): ', 1) : '';
}

$opt{output_dir} ||= $opt{experiment};

for my $required (qw(project_dir sample_file experiment output_dir repo_root)) {
    die "Missing required option: $required\n" if !defined $opt{$required} || $opt{$required} eq '';
}

die "Sample file not found: $opt{sample_file}\n" if !-f $opt{sample_file};

my $template_dir = "$opt{repo_root}/templates/slurm";
my $postprocess_dir = "$opt{repo_root}/templates/postprocess";
my $config_dir   = "$opt{repo_root}/config";
my $scripts_dir  = "$opt{repo_root}/scripts";

for my $dir ($template_dir, $config_dir, $scripts_dir) {
    die "Required directory not found: $dir\n" if !-d $dir;
}
die "Required directory not found: $postprocess_dir\n" if $opt{include_postprocess} && !-d $postprocess_dir;

my @samples = read_samples($opt{sample_file});
die "No sample IDs found in $opt{sample_file}\n" if !@samples;

make_path($opt{output_dir}) unless -d $opt{output_dir};
my $rendered_sample_file = "$opt{output_dir}/samples.txt";
copy($opt{sample_file}, $rendered_sample_file)
    or die "Failed to copy sample file to $rendered_sample_file: $!\n";

my @templates = (
    [ "$template_dir/common.sh", 'common.sh' ],
    map { [ "$template_dir/$_", $_ ] } qw(
        01_fastqc.sh
        02_align_primary.sh
        03_align_spikein.sh
        04_mark_duplicates.sh
        05_fragment_lengths.sh
        06_make_fragments_bed.sh
        07_bin_fragments.sh
        08_spikein_normalize.sh
        09_call_peaks_seacr.sh
    ),
);

if ($opt{include_postprocess}) {
    push @templates,
        [ "$postprocess_dir/10_make_bigwig.sh", '10_make_bigwig.sh' ],
        [ "$postprocess_dir/11_plot_heatmap.sh", '11_plot_heatmap.sh' ];
}

for my $template (@templates) {
    my ($input_file, $output_name) = @$template;
    render_template(
        input_file  => $input_file,
        output_file => "$opt{output_dir}/$output_name",
        sample_count => scalar @samples,
        project_dir => $opt{project_dir},
        sample_file => $rendered_sample_file,
        mail_user   => $opt{mail_user},
    );
}

copy_if_missing("$config_dir/pipeline.env.example", "$opt{output_dir}/pipeline.env");
copy_if_missing("$config_dir/control_map.tsv.example", "$opt{output_dir}/control_map.tsv");
copy("$scripts_dir/submit_chain.pl", "$opt{output_dir}/submit_chain.pl")
    or die "Failed to copy submit_chain.pl: $!\n";
chmod 0755, "$opt{output_dir}/submit_chain.pl"
    or die "Cannot chmod $opt{output_dir}/submit_chain.pl: $!\n";

print "Experiment directory created: $opt{output_dir}\n";
print "Samples detected: " . scalar(@samples) . "\n";
print "Copied sample manifest to: $rendered_sample_file\n";
print "Next steps:\n";
print "  1. Edit $opt{output_dir}/pipeline.env\n";
print "  2. Edit $opt{output_dir}/control_map.tsv\n";
print "  3. Dry-run submission with: perl $opt{output_dir}/submit_chain.pl --dry-run\n";
print "  4. Optional: generated post-processing steps 10-11 are included\n" if $opt{include_postprocess};

sub usage {
    return <<"USAGE";
Usage:
  perl scripts/generate_experiment.pl --project-dir PATH --sample-file FILE --experiment NAME [options]

Options:
  --project-dir PATH   Analysis directory where workflow outputs will be written
  --analysis-dir PATH  Alias for --project-dir
  --sample-file FILE   Plain-text file with one sample ID per line
  --experiment NAME    Name of the generated experiment directory
  --mail-user EMAIL    Email for Slurm END/FAIL notifications
  --output-dir PATH    Output directory for the generated scripts (defaults to experiment name)
  --repo-root PATH     Override repo root discovery
  --include-postprocess
                       Also generate optional deepTools post-processing steps 10-11
  --help               Show this message
USAGE
}

sub prompt {
    my ($message, $allow_empty) = @_;
    while (1) {
        print $message;
        my $value = <STDIN>;
        if (!defined $value) {
            return '' if $allow_empty;
            next;
        }
        chomp($value);
        return $value if $allow_empty || $value ne '';
    }
}

sub read_samples {
    my ($sample_file) = @_;
    open my $fh, '<', $sample_file or die "Cannot open $sample_file: $!\n";

    my @samples;
    while (my $line = <$fh>) {
        chomp $line;
        $line =~ s/\r$//;
        next if $line =~ /^\s*$/;
        next if $line =~ /^\s*#/;
        push @samples, $line;
    }

    close $fh;
    return @samples;
}

sub shell_single_quote {
    my ($text) = @_;
    $text =~ s/'/'"'"'/g;
    return "'$text'";
}

sub render_template {
    my (%args) = @_;

    open my $in, '<', $args{input_file} or die "Cannot open $args{input_file}: $!\n";
    my @content = <$in>;
    close $in;

    my $project_q = shell_single_quote($args{project_dir});
    my $sample_q  = shell_single_quote($args{sample_file});

    my @replacement = (
        "#SBATCH --array=1-$args{sample_count}%$args{sample_count}\n",
    );

    if (defined $args{mail_user} && $args{mail_user} ne '') {
        push @replacement,
            "#SBATCH --mail-type=END,FAIL\n",
            "#SBATCH --mail-user=$args{mail_user}\n";
    }

    push @replacement,
        "projPath=$project_q\n",
        "sample_file=$sample_q\n",
        'sample="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$sample_file")"' . "\n",
        'sample="$(printf "%s" "$sample" | tr -d "\r")"' . "\n",
        '[[ -n "$sample" ]] || { echo "No sample found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID}" >&2; exit 1; }' . "\n";

    my @rendered;
    for my $line (@content) {
        if ($line =~ /#__CUTANDRUN_GENERATED_CONFIG__/) {
            push @rendered, @replacement;
        } else {
            push @rendered, $line;
        }
    }

    open my $out, '>', $args{output_file} or die "Cannot write $args{output_file}: $!\n";
    print {$out} @rendered;
    close $out;
    chmod 0755, $args{output_file} or die "Cannot chmod $args{output_file}: $!\n";
}

sub copy_if_missing {
    my ($source, $dest) = @_;
    return if -e $dest;
    copy($source, $dest) or die "Failed to copy $source to $dest: $!\n";
}
