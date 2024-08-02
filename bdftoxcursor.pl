#!/usr/bin/perl

use warnings;
use strict;

use Image::Magick;

# https://tldp.org/HOWTO/X-Big-Cursor-3.html
# xserver dix/glyphcurs.c:63
# cursor-misc cursor.bdf
# https://github.com/charakterziffer/cursor-toolbox
# https://gitlab.gnome.org/GNOME/gtk/-/blob/main/gdk/x11/gdkcursor-x11.c#L104
# https://www.gnome-look.org/p/999853/
# https://www.x.org/docs/BDF/bdf.pdf

my $name;
my $bbx;
my %glyphs;
while(<>) {
	chomp;
	if(/^STARTCHAR (.*)/) {
		$name = $1;
	} elsif(/^BBX (.*) (.*) (.*) (.*)/) {
		$bbx = [$1, $2, $3, $4];
	} elsif(/^BITMAP/) {
		my @bitmap;
		while(<>) {
			chomp;
			last if(/ENDCHAR/);
			push @bitmap, [split //, unpack("B*", pack("H*", $_))];
#			push @bitmap, [split(//, substr(unpack("B*", pack("H*", $_)), 0, $bbx->[0]))];
#			push @bitmap, substr(unpack("B*", pack("H*", $_)), 0, $bbx->[0]);
		}
		$glyphs{$name} = [$bbx, \@bitmap];
	}
}

#use Data::Dumper;
#print Dumper \%glyphs;
#exit;

foreach my $key (sort keys %glyphs) {
	next if($key =~ /_mask$/);
#	next if($key ne "left_ptr");
	my $src = $glyphs{$key};
	my $mask = $glyphs{$key . "_mask"};

	my $image = Image::Magick->new;
	# xcursorgen wants squares so we make every cursor a square instead
#	$image->Set(size=>$mask->[0][0] . 'x' . $mask->[0][1]);
	$image->Set(size=>'16x16');
	$image->ReadImage('canvas:black');
	$image->Set(alpha => 'transparent');

	for my $x (0 .. $mask->[0][0]) {
		for my $y (0 .. $mask->[0][1]) {
			my $alpha = $mask->[1][$y][$x] ? 255 : 0;
			my $color = 255;
			# src and mask are aligned to each other by their
			# origins described in the BBX line.  Calculate this
			# into $dx and $dy
			my $dx = $mask->[0][2] - $src->[0][2];
			my $dy = $mask->[0][3] - $src->[0][3];
			if($alpha) {
				if(inbound($x + $dx, $src->[0][0]) and inbound($y + $dy, $src->[0][1])) {
					$color = $src->[1][$y + $dy][$x + $dx] ? 0 : 255;
				}
				$image->SetPixel(x=>$x, y=>$y, color=> [$color, $color, $color, 1.0]);
			} else {
				$image->SetPixel(x=>$x, y=>$y, channel => 'alpha', color=> [$alpha]);
			}
		}
	}
	print "writing $key\n";
	$image->Write("work/$key.png");
	
	#        <size> <xhot> <yhot> <filename> <ms-delay>
	open(my $cfg, ">", "work/$key.cfg");
	print $cfg "16 " . (-1*$mask->[0][2]) . " " . ($mask->[0][1] + $mask->[0][3]) . " work/$key.png\n";
	close($cfg);

	`xcursorgen work/$key.cfg cursors/$key`;
}

sub inbound {
	my ($x, $xmax) = @_;
	return 0 if($x < 0);
	return 0 if($x >= $xmax);
	return 1;
}
