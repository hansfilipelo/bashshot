bashShot
=================================
Replicates the Solaris time-slider functionality as shell script with help of cron. Tested on Debian and Ubuntu GNU/Linux with ZFSonLinux (zfsonlinux.org).


LICENSE
=================================
    bashShot - Time Slider-like implementation for ZFSonLinux using cron
    Copyright (C) <year>  Hans-Filip Elo

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

INSTALLATION
=================================
These scripts needs crontab/anacron, which are installed by default on Debian and Ubuntu. You also need ZFSonLinux (zfsonlinux.org). 

Clone project, cd to folder: 

	git clone git://github.com/hansfilipelo/bashshot.git
	cd bashshot

Run install.sh: 

	sudo ./install.sh

Edit /etc/bashshot/bashshot.conf. Set FILESYSTEMS to snapshot and wanted periods on snapshots. Example below: 

	FILESYSTEMS=$(array 'pool/filesystem' 'pool/filesystem')
	frequently="no"
	hourly="no"
	daily="yes"
	weekly="yes"
	monthly="yes"


UNINSTALL
=================================
Run uninstall.sh

	sudo ./uninstall.sh
	# To also remove config
	sudo ./uninstall.sh purge

REQUIREMENTS
=================================
Should run on any *NIX system that has crontab and ZFS (zfsonlinux.org) installed. 

