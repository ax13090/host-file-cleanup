#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Data::Dumper;
use File::Basename;
use File::Spec;
use File::Copy;

sub main {
	
	# Check argument, and stop everything if the script
	# is invoked with no arguments or too many
	die "A single argument is expected" if (@ARGV != 1);
	my $input_path = $ARGV[0];

	my $output_path = $input_path . '_cleaned';
	die "$output_path already exists" if -e $output_path;

	open (my $read_file_handle,  '<', $input_path)  or die;
	open (my $write_file_handle, '>', $output_path) or die;
	my %seen;
	my $discard_count = 0;
	
	while (<$read_file_handle>) {
		if (m/^\s*(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+([a-zA-Z0-9\-\.]+)/) {
			my $address = $1;
			my $name = $2;
			if (defined $seen{$name}) {
				++$discard_count;
				next;
			}

			$seen{$name} = $address;
		}
		print $write_file_handle $_;
	}

	close $read_file_handle or die;
	close $write_file_handle or die;
	
	print "$discard_count lines discarded\n";
}

main();
