bashShot
=================================
Replicates the Solaris sun-auto-snap functionality as shell script with help of cron. Tested on Debian and Ubuntu GNU/Linux with ZFSonLinux (zfsonlinux.org).


LICENSE
=================================
    bashShot - sun-auto-snap-like implementation for ZFSonLinux using cron
    Copyright (C) 2014  Hans-Filip Elo, Christian Luckey

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

REQUIREMENTS
=================================
Should run on any Linux system that has bash, cron and ZFS (zfsonlinux.org) installed, but has only been tested on Debian and Ubuntu. If you are interested in running bashShot on another distro or OS, please proceed in caution and confirm it's operability.

INSTALLATION
=================================
These scripts needs bash and cron/anacron, which are installed by default on Debian and Ubuntu. You also need ZFSonLinux (zfsonlinux.org). Note that the author recommends reading and understanding any script before running it as root.

Clone the project and switch to it's folder:

	git clone git://github.com/hansfilipelo/bashshot.git
	cd bashshot

Install the software on your system:

	sudo ./install.bash

Edit /etc/bashshot/bashshot.conf. Set which filesystems to snapshot and the periocity of these snapshots. Example below:

	filesystems=$(array 'pool/filesystem' 'pool/filesystem')
	frequently="no"
	hourly="no"
	daily="yes"
	weekly="yes"
	monthly="yes"


UNINSTALL
=================================
Simply run uninstall.bash:

	sudo ./uninstall.bash
	# To also remove config
	sudo ./uninstall.bash purge
