
--==:  dynaMenu - The Dynamic Menu  :==--
-----------------------------------------


 * ABOUT

There are two versions available - menu_Curses & menu_noCurses - 
the Curses version has colours and uses Curses.pm. If you need 
Curses see http://www.cpan.org/. The noCurses version is developed 
for korn shell environments like HP-UX.


* LICENSING

Please see the file COPYING.


* DOWNLOAD

You can get the files from http://www.hirdman.net/. If you want to 
mirror it, send me an email.

* INSTALL

Untar the file dynaMenu-xx.xx.tar.gz at location of your choice. In the 
directory created you will find menu_Curses and menu_noCurses, choose 
the menu_* dir that best fits your need and copy it to the place
you want it (eg. /opt/menu).


* USAGE

To start dynaMenu just change directory to /opt/menu (or wherever 
you installed dynaMenu), type ./menu.pl and enjoy.


* BUILDING YOUR MENU

The concept of dynaMenu is that each subdirectory is a submenu and 
each file a menu choice, if you add a file it will automatically 
show up in the menu. By default some files and directories are 
excluded:

	- If they begin with a ".".
	- If they are named *.sql.
	- All files named as the menu script.
	- If they end with "~"

This list is defined in the subroutine named dir_read, if you need
to add or remove anything edit the regexp in that subroutine.
By default the menu choices will have the same name as the file or
directory, if you wish to have custom names for files then add the 
following line at the beginning of the file:

# Description: Your Cool name here

For directories create a file in the directory named .message, or
better yet, copy the file from the basedir and edit it to your 
liking. An Example:

# Name: The title of the menu
# Description: The name shown in the parent menu

Thats all there is to it.


* BUGS / SUGGESTIONS

Please visit the dynaMenu forum at http://www.hirdman.net/ or 
send me an email and I'll take a look.


* AUTHOR

- Love Hirdman
- love@hirdman.net

