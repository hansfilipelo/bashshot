bashShot
=================================
Replicates the Solaris time-slider functionality as shell script with help of cron. Tested on Debian and Ubuntu GNU/Linux with zfsonlinux.


LICENSE
=================================
This software is released as free software. You are free to download, distribute and change it as you like. This software comes with absolutely NO WARRANTY. Use at your own risk. 


INSTALLATION
=================================
These scripts needs crontab/anacron, which are installed by default on Debian and Ubuntu. You also need ZFSonLinux (zfsonlinux.org). 

Clone project, cd to folder: 

	git clone git://github.com/hansfilipelo/bashshot.git
	cd bashshot

Run install.sh: 

	./install.sh

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

	./uninstall.sh


REQUIREMENTS
=================================
Should run on any *NIX system that has crontab and ZFS (zfsonlinux.org) installed. 

