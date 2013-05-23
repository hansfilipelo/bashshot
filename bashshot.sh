#!/bin/bash

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Gets date and filesystems (FS) from FS file
FILESYSTEMS=/etc/bashshot/filesystems.list
DATE=$(date +%Y%m%d%H%M)
LOG=/var/log/bashshot.log

# Creates temporary file which will be sent to logs@cyd.liu.se
TEMP=/tmp/log.txt
touch $TEMP
exec >> $TEMP 2>&1

# Sets scripts period
if [ $1 == "frequently" -o $1 == "hourly" -o $1 == "daily" -o $1 == "weekly" -o $1 == "monthly" ]
then
	PERIOD=$1
else
	echo ""
	echo "Usage:"
	echo "	bashshot.sh <frequently|hourly|daily|weekly|monthly|>"
	echo ""
	# Outputs TEMP to LOG
	cat $TEMP >> $LOG
	rm $TEMP
	exit
fi

# Echos stuff
echo ""
echo "Written by bashshot.sh"
echo "-------------------------"
date "+%Y-%m-%d %H:%M"

# Loops through FS to snapshot
while read FS
do
	/sbin/zfs snapshot $FS@$PERIOD-$DATE
	
	if [ $? == 0 ]
	then
		echo "$PERIOD snapshot of $FS taken"
	else
		echo "$PERIOD SNAPSHOT OF $FS FAILED!"
	fi
done < $FILESYSTEMS

echo "------------------------"

# Sends email
#cat $TEMP | mailx -s "bashshot.sh reporting for duty" logs@cyd.liu.se

# Appends stuff in TEMP/mail to log
cat $TEMP >> $LOG
rm $TEMP

