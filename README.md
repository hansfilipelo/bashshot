bashShot
=================================
Replicates the Solaris time-slider functionality as shell script with help of cron. Tested on Debian and Ubuntu GNU/Linux with zfsonlinux.


LICENSE
=================================
This software is released as free software. You are free to download, distribute and change it as you like. This software comes with absolutely NO WARRANTY. Use at your own risk. 


INSTALLATION
=================================
Clone project, cd to folder: 

	git clone git://github.com/hansfilipelo/bashshot.git
	cd bashshot

Run install.sh: 

	./install.sh

Edit /etc/bashshot/bashshot.conf. Set FILESYSTEMS to snapshot and wanted periods on snapshots: 

	FILESYSTEMS=$(array 'pool/filesystem' 'pool/filesystem')
	frequently="no"
	daily="yes"
	weekly="yes"


UNINSTALL
=================================
Run uninstall.sh

	./uninstall.sh


REQUIREMENTS
=================================
Should run on any *NIX system that has crontab and ZFS (zfsonlinux.org) installed. 

