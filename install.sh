#!/bin/bash

# If something fails - exit
set -e

# Variables
CONFIGFOLDER=/etc/bashshot
CONFIG=/etc/bashshot/bashshot.conf
# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Check if root
if [[ whoami != "root" ]]; then
	echo "Must be root to run this installer."
	exit 1;
fi

#--------------------------------------------------------- 

# Installing scripts
cp $DIR/bashshot.sh /usr/bin/
cp $DIR/bashshot_cleaner.sh /usr/bin/

#---------------------------------------------------------

# Saves crontab temporary
CRONTAB=$DIR/mycron
touch $CRONTAB
crontab -l > $CRONTAB

# --------------------------

# Installing logrotate for /var/log/bashshot.log
touch /var/log/bashshot.log
touch /etc/logrotate.d/bashshot

cat $DIR/logrotate.txt > /etc/logrotate.d/bashshot

# --------------------------
# Creates configfolder
mkdir -p $CONFIGFOLDER
if [ -f $CONFIG]
then
	echo "Config files exists, will not overwrite it."
else
	# Creates config file
	touch $CONFIG
	# Fill config with default values
	cat >> $CONFIG << '_EOF_'
# This is the config file for bashShot - Time Slider-like (from Solaris) functionality
# For ZFSonLinux implemented as shell script
# 		-----------------------
# Enter filesystems to snapshot as a bash array, i e: 
# 		FILESYSTEMS = (poolX/fsY poolZ/fsW)

	FILESYSTEMS = ()

# Every 15 minutes - saved for an hour
	frequent = no
# Every hour - saved for a day
	hourly = no
# Every day - saved for a week
	daily = no
# Every week - saved for a month
 	weekly = no
# Every month - saved for a year
 	monthly = no

'_EOF_'
fi

# Install into crontab
echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
echo "0,15,30,45 * * * * /usr/bin/bashshot.sh" >> $CRONTAB

# Sets crontab
crontab $CRONTAB
rm $CRONTAB

#---------------------------------------------------------
# Confirm install
echo ""
echo "Installed bashShot succesfully!"

exit 0;