#!/usr/bin/perl
#
#	 --==:  dynaMenu  :==--
#
#	 - Curses free version -
#
#
#	Created:        20070307
#	Created by:	lohi
#	Last udate:	20070627
#
#	Copyright (C) 2007 Love Hirdman
#

use strict;
use Cwd;

{
	my $input = 999;
	my $basedir = getcwd;
	while ( $input != 99 ){
		my %envs = &envs();
		my $envs = \%envs;
		my $pwd = $envs->{'pwd'};
		my @files = &get_list($envs->{'pwd'});
		my @choices = &show_menu($pwd,$envs->{'title'},@files);
	print "4\n";
		&run_choice($pwd,$basedir,@choices);
	print "5\n";
	}
	&leave();
}

sub dir_read {
	my $dir = pop;
	opendir(CURRENT,$dir) or die "No such directory: $!";
	my @list = grep { !/^\./ && !/\.sql$/ && !/^menu\.pl/ && !/\~$/ }  readdir(CURRENT);
	closedir CURRENT;
	return(@list);
}

sub envs {
	my $pwd=getcwd;
	my $title=&get_title($pwd);
	my %envs = (
		pwd   => "$pwd",
		title => "$title"
	);
	return %envs;
}

sub run_choice {
	my $input = pop;
	my $choice = pop;
	my $name = pop;
	my $basedir = pop;
	my $pwd = pop;
	if ( "$pwd/$choice" eq "$basedir/.." ) {
		&leave();
	}
	if ( -d "$pwd/$choice" ) {
		chdir "$pwd/$choice";
	} elsif ( -f "$pwd/$choice" ) {
		print "\e[2J";
		print "\n-- Output from: $name --\n\n";
		system("$pwd/$choice","$pwd");
		if ($? == -1) {
			print "failed to execute: $!\n";
		} elsif ($? & 127) {
			printf "child died with signal %d, %s coredump\n",($? & 127),  ($? & 128) ? 'with' : 'without';
 		}
		print "\n--  Press enter to return  --\n";
		getc;
	}
}

sub get_title {
	my $pwd = $_[0];
	my $t;
	if ( -f "$pwd/.message" ) {
			open(TITLE,"$pwd/.message") or die "No title file: $!";
		foreach (<TITLE>) {
			if ( $_ =~/^#\s+Name:\s+(.*)$/ ){
				$t= $1;
			}
		}
		close TITLE;
	} else {
		$t = "Default Name";
	}
	return $t;
}

sub get_name {
	my $pwd = shift;
	my $file = shift;
	my $name = shift;
	my $i = 0;
	my $t;
	if ( -f "$pwd/$file" ) {
		open(AFILE,"$pwd/$file") or die "No such file: $!";
		foreach (<AFILE>) {
			if ( $_ =~/^#\s+Description:\s+(.*)$/ ){
				$t = $1;
				$i = 1;
			}
		}
		close AFILE;
	} else {
		$t = $name;
		$i = 1;
	}
	if ( $i != 1 ) {
		$t = $file;
	}
	return "$t";
}

sub get_list {
	my $dir = $_[0];
	my @list = &dir_read($dir);
	@list = &sort_list($dir,@list);
	return @list;
}

sub sort_list {
	my $dir = shift;
	my @list = @_;
	my @files;
	my @dirs;
	foreach (@list) {
		if ( -f "$dir/$_" ) {
			push @files,$_;
		} elsif ( -d "$dir/$_" ) {
			push @dirs,$_;
		}
	}
	return @dirs,@files;
}

sub show_menu {
	my $pwd = shift;
	my $title = shift;
	my @files = @_;
	my $name;
	my $input = 999;
	my $i = 0;
	while ( $input > $i && $input != 99 ) {
		$input = 999;
		$i = 0;
		print "\e[2J";
		my $x=$i+1;
		print "\e[${x};10H"."$title\n";
		my $ti=5;
		my $ii=0;
		my $mi=$i;
		foreach ( @files ) {
			$i++;
			if ( $i > 10 && $i < 21 ) {
				$ti = 30;
				$ii = $i - 10;
				$mi = 10;
			} elsif ( $i >= 21 ) {
				$ti = 55;
				$ii = $i - 20;
				$mi = 10;
			} else {
				$ii = $i;
				$mi = $i;
			}
			if ( -f "$pwd/$_" ) {
				$x=$ii+2;
				$name = &get_name($pwd,$_);
				print "\e[${x};${ti}H"."$i) $name\n";
			} elsif ( -d "$pwd/$_" ) {
				$x=$ii+2;
				my $file = "$_/.message";
				$name = &get_name($pwd,$file,$_);
				print "\e[${x};${ti}H"."$i) $name ->\n";
			}
		}
		$x=$mi+5;
		print "\e[${x};10H"."99) Exit\n";
		$x=$mi+6;
		print "\e[${x};10H"."0) Return\n";
		$x=$mi+8;
		print "\e[${x};10H"."-> ";
		chomp($input = <STDIN>);
		if ( $input =~ /[qQ]/ ) {
			$input = 99;
		} elsif ( $input =~ /[bB]/ ) {
			$input = 0;
		} elsif ( $input =~ /\D+/ || $input =~ /^$/ ) {
			$input = 999;
		}
		if ( $input > $i && $input != 99 ) {
		}
	}
	my $choice;
	if ( $input == 0 ) {
		$choice = "..";
	} elsif ( $input == 99 ) {
		&leave();
	} else {
		$choice = $files[$input-1];
	}
	return($name,$choice,$input);
}

sub leave() {
	print "\e[2J";
	exit;
}
