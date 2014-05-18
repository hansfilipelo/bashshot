#!/bin/bash

# Check if root
if [[ whoami -ne "root" ]]; then
	echo "Must be root to run this script."
	exit 1;
fi

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Path to ZFS
ZFS=/sbin/zfs

# Gets date and filesystems (FS) from config file
. /etc/bashshot/bashshot.conf
DATE=$(date '+%Y-%m-%d_%H:%M')
LOG=/var/log/bashshot.log

# Creates temporary file which will be sent to logfile
TEMP=/tmp/log.txt
touch $TEMP
if [[ $1 != "DEBUG" ]]
then
	exec >> $TEMP 2>&1
fi

# Decide which periods that is to be snapshoted
if [[ $frequently == "yes" ]]
then
	PERIOD=$(array "$PERIOD" 'frequently')
fi

if [[ $hourly == "yes" && $(date '+%M') == "00" ]]
then
	PERIOD=$(array "$PERIOD" 'hourly')
fi

if [[ $daily == "yes" && $(date '+%H:%M') == "00:00" ]]
then
	PERIOD=$(array "$PERIOD" 'daily')
fi

if [[ $weekly == "yes" && $(date '+%u %H:%M') == "7 00:00" ]]
then
	PERIOD=$(array "$PERIOD" 'weekly')
fi

if [[ $monthly == "yes" && $(date '+%d %H:%M') == "01 00:00" ]]
then
	PERIOD=$(array "$PERIOD" 'monthly')
fi

# Writes if debug set
if [[ $1 == "DEBUG" ]]; then
	echo "DEBUG: Periods to snapshot"
	echo "$PERIOD" | while IFS= read element
	do
		echo "$element"
	done
fi

# Echos stuff
echo ""
echo "Written by bashshot.sh"
echo "-------------------------"
date "+%Y-%m-%d %H:%M"

#Loops through periods to run
echo "$PERIOD" | while IFS= read TIME
do
	# Loops through FS to snapshot, but skip empty
	echo "$FILESYSTEMS" | while IFS= read FS
	do
		if [[ -n $TIME ]]
		then
			$ZFS snapshot $FS@"$TIME"_"$DATE"
			# Confirm status to log
			if [ $? == 0 ]
			then
				echo "$TIME snapshot of $FS taken"
			else
				echo "$TIME SNAPSHOT OF $FS FAILED!"
			fi
		fi
	done
done

echo "------------------------"

# Appends stuff in TEMP/mail to log

# Write to log
if [[ $1 != "DEBUG"  ]]
then
	cat $TEMP >> $LOG
fi

#Removes temporary log file
rm $TEMP

exit 0;

