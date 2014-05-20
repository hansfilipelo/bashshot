#!/bin/bash

# If something fails - exit
set -e

# Variables
CONFIGFOLDER="/etc/bashshot"
CONFIG="/etc/bashshot/bashshot.conf"
# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Check if root
if [[ whoami -ne "root" ]]; then
	echo "Must be root to run this installer."
	exit 1;
fi

#--------------------------------------------------------- 

# Installing scripts
cp $DIR/bashshot.sh /usr/bin/
cp $DIR/bashshot_cleaner.sh /usr/bin/
cp $DIR/array /usr/bin/

#---------------------------------------------------------

# Installing logrotate for /var/log/bashshot.log
touch /var/log/bashshot.log
touch /etc/logrotate.d/bashshot

cat $DIR/logrotate.txt > /etc/logrotate.d/bashshot

# --------------------------
# Creates configfolder
mkdir -p $CONFIGFOLDER
if [[ -f $CONFIG ]]
then
	echo "Config files exists, will not overwrite it."
else
	# Creates config file
	touch $CONFIG
	# Fill config with default values
	cat >> $CONFIG << _EOF_
#
# This is the config file for bashShot - Time Slider-like (from Solaris) functionality
# For ZFSonLinux implemented as shell script
# 		-----------------------

# Gets array, a POSIX compliant array implementation
# This implementation is created by makefu@github - https://github.com/makefu/array
. /usr/bin/array

# Enter filesystems to snapshot as a array, i e: 
# 		'FILESYSTEMS=$(array 'poolX/fsY' 'poolZ/fsW')'

FILESYSTEMS=

# Choose time period for scripts to snapshot
# Every 15 minutes - saved for an hour
frequently="no"
# Every hour - saved for a day
hourly="no"
# Every day - saved for a week
daily="no"
# Every week - saved for a month
weekly="no"
# Every month - saved for a year
monthly="no"

_EOF_
fi

# Creates crontab
CRONTAB=/etc/cron.d/bashshot
touch $CRONTAB
chmod a+x /etc/cron.d/bashshot
# Install into crontab
echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" > $CRONTAB
echo "00,15,30,45 * * * * root /usr/bin/bashshot.sh" >> $CRONTAB
echo "# Cleaner scripts" >> $CRONTAB
echo "01,16,31,46 * * * * root /usr/bin/bashshot_cleaner.sh frequently" >> $CRONTAB
echo "02 * * * * root /usr/bin/bashshot_cleaner.sh hourly" >> $CRONTAB
echo "03 03 * * * root /usr/bin/bashshot_cleaner.sh daily" >> $CRONTAB
echo "03 04 * * 0 root /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
echo "03 05 1 * * root /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
echo ""

#---------------------------------------------------------
# Confirm install
echo ""
echo "Installed bashShot succesfully!"

exit 0;
