#!/bin/bash

# Check if root
if [[ whoami -ne "root" ]]; then
	echo "Must be root to run this script."
	exit 1;
fi

# cd to script dir
cd "$( dirname "$0" )"

# Path to ZFS
ZFS=/sbin/zfs

# Gets date and filesystems (FS) from config file
. /etc/bashshot/bashshot.conf
date=$(date '+%Y-%m-%d_%H:%M')
logPath=/var/log/bashshot.log

# Creates temporary file which will be sent to logfile
tempLogPath=/tmp/log.txt
touch $tempLogPath
if [[ $1 != "DEBUG" ]]
then
	exec >> $tempLogPath 2>&1
fi

# Decide which periods that is to be snapshoted
if [[ $frequently == "yes" ]]
then
	period=$(array "$period" 'frequently')
fi

if [[ $hourly == "yes" && $(date '+%M') == "00" ]]
then
	period=$(array "$period" 'hourly')
fi

if [[ $daily == "yes" && $(date '+%H:%M') == "00:00" ]]
then
	period=$(array "$period" 'daily')
fi

if [[ $weekly == "yes" && $(date '+%u %H:%M') == "7 00:00" ]]
then
	period=$(array "$period" 'weekly')
fi

if [[ $monthly == "yes" && $(date '+%d %H:%M') == "01 00:00" ]]
then
	period=$(array "$period" 'monthly')
fi

# Writes if debug set
if [[ $1 == "DEBUG" ]]; then
	echo "DEBUG: Periods to snapshot"
	echo "$period" | while IFS= read element
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
echo "$period" | while IFS= read time
do
	# Loops through FS to snapshot, but skip empty
	echo "$filesystems" | while IFS= read fs
	do
		if [[ -n $time ]]
		then
			$ZFS snapshot $fs@"$time"_"$date"
			# Confirm status to log
			if (( $? == 0 ))
			then
				echo "$time snapshot of $fs taken"
			else
				echo "$time SNAPSHOT OF $fs FAILED!"
			fi
		fi
	done
done

echo "------------------------"

# Appends stuff in tempLogPath/mail to log

# Write to log
if [[ $1 != "DEBUG"  ]]
then
	cat $tempLogPath >> $logPath
fi

#Removes temporary log file
rm $tempLogPath

exit 0;
