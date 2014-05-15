#!/bin/bash

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Path to ZFS
ZFS=/sbin/zfs

# Gets date and filesystems (FS) from config file
source /etc/bashshot/bashshot.conf
DATE=$(date '+%Y-%m-%d %H:%M')
LOG=/var/log/bashshot.log

# Creates temporary file which will be sent to logfile
TEMP=/tmp/log.txt
touch $TEMP
exec >> $TEMP 2>&1


# Decide which periods that is to be snapshoted
declare -a PERIOD
IT=0

if [[ $frequent == yes ]]; then
	PERIOD[$IT]='frequent'
	IT=$IT+1
fi
if [[ $hourly == yes && $(date '+%M') == "00" ]]; then
	PERIOD[$IT]='hourly'
	IT=$IT+1
fi
if [[ $daily == yes && $(date '+%H:%M') == "00:00" ]]; then
	PERIOD[$IT]='daily'
	IT=$IT+1
fi
if [[ $weekly == yes && $(date '+%u %H:%M') == "7 00:00" ]]; then
	PERIOD[$IT]='weekly'
	IT=$IT+1
fi
if [[ $monthly == yes && $(date '+%d %H:%M') == "1 00:00"]]; then
	PERIOD[$IT]='monthly'
	IT=$IT+1
fi

# Echos stuff
echo ""
echo "Written by bashshot.sh"
echo "-------------------------"
date "+%Y-%m-%d %H:%M"

#Loops through periods to run
for TIME in $PERIOD
	# Loops through FS to snapshot
	for FS in $FILESYSTEMS
		$ZFS snapshot $FS@$PERIOD-$DATE
		# Confirm status
		if [ $? == 0 ]
		then
			echo "$TIME snapshot of $FS taken"
		else
			echo "$TIME SNAPSHOT OF $FS FAILED!"
		fi
	done
done

echo "------------------------"

# Sends email
#cat $TEMP | mailx -s "bashshot.sh reporting for duty" logs@cyd.liu.se

# Appends stuff in TEMP/mail to log

# Write to log once a week and every month
if [ $PERIOD == "weekly" -o $PERIOD == "monthly" ]
then 
	cat $TMP >> $LOG
fi

#Removes temporary files
rm $TEMP
