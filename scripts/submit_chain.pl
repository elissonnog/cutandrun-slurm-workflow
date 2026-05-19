#!/usr/bin/env perl
use strict;
use warnings;

use Cwd qw(abs_path);
use Getopt::Long qw(GetOptions);

my %opt = (
    experiment_dir => '.',
    sbatch_cmd     => 'sbatch',
    dry_run        => 0,
);

GetOptions(
    'experiment-dir=s' => \$opt{experiment_dir},
    'sbatch-cmd=s'     => \$opt{sbatch_cmd},
    'dry-run'          => \$opt{dry_run},
    'help'             => \$opt{help},
) or die usage();

if ($opt{help}) {
    print usage();
    exit 0;
}

my $dir = abs_path($opt{experiment_dir})
    or die "Experiment directory not found: $opt{experiment_dir}\n";

my @candidates = (
    "$dir/1_fastqc.sh",
    "$dir/2_bowtie.sh",
    "$dir/3_bowtie_coli.sh",
    "$dir/4_picard.sh",
    "$dir/5_samtools.sh",
    "$dir/6_conv.sh",
    "$dir/7_conv2.sh",
    "$dir/8_spike.sh",
    "$dir/9_seacr.sh",
);

for my $script (@candidates) {
    die "Missing script: $script\n" if !-f $script;
}

my $previous_job_id = '';
my $dry_run_job_id = 0;

for my $script (@candidates) {
    my @cmd = ($opt{sbatch_cmd});
    push @cmd, "--dependency=afterok:$previous_job_id" if $previous_job_id ne '';
    push @cmd, $script;

    if ($opt{dry_run}) {
        print join(' ', @cmd), "\n";
        $dry_run_job_id++;
        $previous_job_id = "DRYRUN$dry_run_job_id";
        next;
    }

    my $command = join(' ', @cmd);
    print "Submitting: $command\n";
    my $output = `$command 2>&1`;
    die "Failed to submit $script\n$output" if $?;

    if ($output =~ /Submitted batch job (\d+)/) {
        my $current_job_id = $1;
        if ($previous_job_id eq '') {
            print "Submitted $script as job $current_job_id\n";
        } else {
            print "Submitted $script as job $current_job_id after $previous_job_id\n";
        }
        $previous_job_id = $current_job_id;
    } else {
        die "Could not parse sbatch output for $script\n$output";
    }
}

print "Done.\n" if !$opt{dry_run};

sub usage {
    return <<"USAGE";
Usage:
  perl submit_chain.pl [--experiment-dir PATH] [--dry-run] [--sbatch-cmd CMD]

Options:
  --experiment-dir PATH  Directory that contains generated step scripts
  --dry-run              Print commands without submitting
  --sbatch-cmd CMD       Override the sbatch executable name
  --help                 Show this message
USAGE
}
