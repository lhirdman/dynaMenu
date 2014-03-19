#!/usr/bin/perl
#
#	 --==:  dynaMenu  :==--
#
#	- Curses based version -
#
#
#	Created:        20070307
#	Created by:	lohi
#	Last update:	20070627
#
#
#
#	Copyright (C) 2007 Love Hirdman
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
#

use strict;
use Cwd;
use Curses;

{
	my $input = 999;
	my $basedir = getcwd;
	while ( $input != 99 ){
		my %envs = &envs();
		my $envs = \%envs;
		my $pwd = $envs->{'pwd'};
		my @files = &get_list($envs->{'pwd'});
		my @choices = &show_menu($pwd,$envs->{'title'},@files);
		&run_choice($pwd,$basedir,@choices);
	}
	&leave();
}

#### The following sub routine defines which files and ####
#### directories that are excluded. Feel free to edit. ####

sub dir_read {
	my $dir = pop;
	opendir(CURRENT,$dir) or die "No such directory: $!";
#	Below is the regexp that defines which files are excluded	
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
#		system("tput","clear");
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
			open(TITLE,"$pwd/.message");
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
	initscr;
	my $input = 999;
	my $i = 0;
	while ( $input > $i && $input != 99 ) {
		$input = 999;
		$i = 0;
		my $win = new Curses;
		start_color;
		init_pair 1, COLOR_BLUE, COLOR_BLACK;
		init_pair 2, COLOR_RED, COLOR_BLACK;
		init_pair 3, COLOR_YELLOW, COLOR_BLACK;
		my $blue = COLOR_PAIR(1);
		my $red = COLOR_PAIR(2);
		my $yellow = COLOR_PAIR(3);
		eval { $win->attron($yellow) };
		eval { $win->attron(A_BOLD) };
		eval { $win->attron(A_UNDERLINE) };
		$win->addstr($i+1,10,"$title");
		eval { $win->attrset(A_NORMAL) };
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
				$name = &get_name($pwd,$_);
				$win->addstr($ii+2,$ti,"$i) $name");
			} elsif ( -d "$pwd/$_" ) {
				my $file = "$_/.message";
				$name = &get_name($pwd,$file,$_);
				eval { $win->attron(A_BOLD) };
				$win->addstr($ii+2,$ti,"$i) $name ->");
				eval { $win->attrset(A_NORMAL) };
			}
			$win->refresh;
		}
		eval { $win->attron($blue) };
		eval { $win->attron(A_BOLD) };
		$win->addstr($mi+5,10,"99) Exit");
		$win->addstr($mi+6,10,"0) Return");
		$win->addstr($mi+8,10,"-> ");
		eval { $win->attrset(A_NORMAL) };
		$win->refresh;
		eval { $win->getnstr($input,2) };
		$win->refresh;
		if ( $input =~ /[qQ]/ ) {
			$input = 99;
		} elsif ( $input =~ /[bB]/ ) {
			$input = 0;
		} elsif ( $input =~ /\D+/ || $input =~ /^$/ ) {
			$input = 999;
		}
		if ( $input > $i && $input != 99 ) {
			eval { $win->attron($red) };
			eval { $win->attron(A_BOLD) };
			$win->addstr($ii+9,8,"Wrong choice!");
			$win->addstr($ii+10,8,"Press enter and retry.");
			eval { $win->getch() };
			eval { $win->attrset(A_NORMAL) };
			eval { $win->clear };
		}
		endwin;
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
#	system("tput","clear");
	exit;
}
