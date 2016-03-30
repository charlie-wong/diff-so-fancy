my $dim_magenta      = "\e[38;5;146m";
my $reset_color      = "\e[0m";
my $bold             = "\e[1m";
my ($file_1,$file_2);
my $last_file_seen = "";
	} elsif ($line =~ /^$ansi_color_regex--- (\w\/)?(.+?)(\e|\t|$)/) {
		$next    =~ /^$ansi_color_regex\+\+\+ (\w\/)?(.+?)(\e|\t|$)/;
		if ($file_2 ne "/dev/null") {
			$last_file_seen = $file_2;
		}
		my $remain       = bleach_text($5);
		print "@ $last_file_seen:$start_line \@${bold}${dim_magenta}${remain}${reset_color}\n";

# Remove + or - at the beginning of the lines
sub strip_leading_indicators {
	my $array = shift();       # Array passed in by reference
	my $columns_to_remove = 1; # Default to 1 (two-way merge)

	foreach my $line (@$array) {
		# If the line is a hunk line, check for two-way vs three-way merge
		# Two-way   = @@ -132,6 +132,9 @@
		# Three-way = @@@ -48,10 -48,10 +48,15 @@@
		if ($line =~ /^${ansi_color_regex}@@@* (.+?) @@@*/) {
			$columns_to_remove = (char_count(",",$4)) - 1;
			last;
		}
	}

	foreach my $line (@$array) {
		# Remove a number of "+", "-", or spaces equal to the indent level
		$line =~ s/^(${ansi_color_regex})[ +-]{${columns_to_remove}}/$1/;
	}

	return 1;
}

# Count the number of a given char in a string
sub char_count {
	my ($needle,$str) = @_;
	my $len = length($str);
	my $ret = 0;

	for (my $i = 0; $i < $len; $i++) {
		my $found = substr($str,$i,1);

		if ($needle eq $found) { $ret++; }
	}

	return $ret;
}

sub bleach_text {
	my $str = shift();
	$str    =~ s/\e\[\d*(;\d+)*m//mg;

	return $str;
}