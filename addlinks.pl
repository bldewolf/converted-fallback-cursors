#!/usr/bin/perl

use warnings;
use strict;

while(<>) {
	chomp;
	next if(!/^  \{/);
	my ($new, undef) = /"([^"]+)"/g;
	my ($old, undef) = /XC_([^ ,]+)/g;
	print "$new $old\n";
	`ln -s -T $old cursors/$new`;
}
