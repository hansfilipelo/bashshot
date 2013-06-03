#!/bin/bash

# Creates temporary files
TMP=/tmp/snapshot_cleanerlog_tmp.txt
touch $TMP
exec >> $TMP 2>&1
SNAPSHOTS=/tmp/snapshots_tmp.txt
touch $SNAPSHOTS

echo ""
echo "Written by bashshot_cleaner.sh"
echo "-----------------------------"
date "+%Y-%m-%d %H:%M"

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Put log in same dir as script
LOG=/var/log/bashshot.log
touch $LOG

# Sets scripts period
if [ $1 == "frequently" -o $1 == "hourly" -o $1 == "daily" -o $1 == "weekly" -o $1 == "monthly" ]
then
        PERIOD=$1
else
        echo ""
        echo "Usage:"
        echo "  bashshot.sh <frequently|hourly|daily|weekly|monthly|>"
        echo ""
        # Outputs TEMP to LOG
        cat $TMP >> $LOG
        rm $TMP
	rm $SNAPSHOTS
        exit
fi

# Gets date
DATE=$(date +%Y%m%d%H%M)

# Sets timediff depending on what interval of snapshots to clean
if [ $PERIOD == frequently ]
then
	# We keep frequently snapshots for an hour
	if [ $(date +%H) == 00 ]
	then
		TIMEDIFF=7700
	else
		TIMEDIFF=100
	fi

elif [ $PERIOD == hourly ]
then
	# We keep hourly snapshots for a day
	TIMEDIFF=10000

elif [ $PERIOD == daily ]
then
	# We keep daily snapshots for a week
	if [ 8 -gt $(date +%d) ]
	then
		TIMEDIFF=750000
	else
		TIMEDIFF=70000
	fi
	
elif [ $PERIOD == weekly ]
then
	# We keep weekly snapshots for a month
	if [ 2 -gt $(date +%m) ]
	then
		TIMEDIFF=89700000
	else
		TIMEDIFF=1000000
	fi
	
elif [ $PERIOD == monthly ]
then
	# We keep monthly snapshots for a year
	TIMEDIFF=100000000

else
	echo ""
	echo "Usage:"
	echo "	bashshot_cleaner.sh <frequently|hourly|daily|weekly|monthly> <log>"
	echo ""
	cat $TMP >> $LOG
	rm $SNAPSHOTS
	rm $TMP
	exit
fi

# Lists snapshots taken with same interval as cleaner
/sbin/zfs list -t snapshot | tail -n+2 | grep @$PERIOD > $SNAPSHOTS

while read line
do
	# Takes out only name part of snapshot-line
	SS=$(echo $line | awk '{print $1}')
	
	# Takes out only date-part of snapshots in storage
	SSDATE=$(echo $line | awk '{print $1}' | sed 's/[^0-9]//g')
	
	# If todays date minus snapshot date minus TIMEDIFF is >0, then it's to old
	# Saves daily for 1 week, weekly for a month and monthly for a year
	DIFF=$(($DATE-$SSDATE-$TIMEDIFF))
	if [ $DIFF -gt 0 ]
	then
		/sbin/zfs destroy $SS
		if [ $? == 0 ]
		then
			echo "$SS destroyed"
		fi
	fi
done < $SNAPSHOTS

# List remaining snapshots
echo ""
echo "Remaining snapshots"
/sbin/zfs list -t snapshot

echo "-----------------------------"

# Write to log once a week and every month
if [ $PERIOD == "weekly" -o $PERIOD == "monthly" ]
then 
	cat $TMP >> $LOG
fi

# Remove temporary files
rm $SNAPSHOTS
rm $TMP

