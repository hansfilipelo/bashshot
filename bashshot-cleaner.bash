#!/bin/bash

# Check if root
if (( $(id -u) != "root" )); then
	echo "The bashshot cleaner script must be run as root."
	exit;
fi

# Creates temporary files
tempLog=/tmp/snapshot_cleanerlog_tmp.txt
touch $tempLog

if [[ ! $2 == "DEBUG" ]]; then
	exec >> $tempLog 2>&1
fi
snapshots=/tmp/snapshots_tmp.txt
touch $snapshots

echo ""
echo "Written by bashshot-cleaner"
echo "-----------------------------"
date "+%Y-%m-%d %H:%M"

# cd to script dir
cd dirname "$0"

# Put log /var/log/
log=/var/log/bashshot-cleaner.log
touch $log

# Sets scripts period
if [[ $1 == "frequent" || $1 == "hourly" || $1 == "daily" || $1 == "weekly" || $1 == "monthly" ]]; then
	period=$1
else
	echo ""
	echo "Usage:"
	echo "	$0 (frequent|hourly|daily|weekly|monthly|)"
	echo ""
	# Outputs tempLog to log
	cat $tempLog >> $log
	rm $tempLog
	rm $snapshots
	exit
fi

date=$(date +%Y%m%d%H%M)

# Sets timediff depending on what interval of snapshots to clean
if [[ $period == frequent ]]; then
	# We keep frequent snapshots for an hour
	if [[ $(date +%H) == 00 ]]; then
		timediff=7700
	else
		timediff=100
	fi

elif [[ $period == hourly ]]; then
	# We keep hourly snapshots for a day
	timediff=10000

elif [[ $period == daily ]]; then
	# We keep daily snapshots for a week
	if [[ 8 -gt $(date +%d) ]]
	then
		timediff=750000
	else
		timediff=70000
	fi

elif [ $period == weekly ]; then
	# We keep weekly snapshots for a month
	if [[ 2 -gt $(date +%m) ]]; then
		timediff=89700000
	else
		timediff=1000000
	fi

elif [[ $period == monthly ]]; then
	# We keep monthly snapshots for a year
	timediff=100000000

else
	echo ""
	echo "Usage:"
	echo "	bashshot_cleaner.sh <frequent|hourly|daily|weekly|monthly> <log>"
	echo ""
	cat $tempLog >> $log
	rm $snapshots
	rm $tempLog
	exit
fi

# Lists snapshots taken with same interval as cleaner
zfs list -t snapshot | tail -n+2 | grep @$period > $snapshots

while read line; do
	# Takes out only name part of snapshot-line
	snapshot=$(echo $line | awk '{print $1}')

	# Takes out only date-part of snapshots in storage
	snapshotDate=$(echo $line | awk '{print $1}' | sed 's/[^0-9]//g')

	# If todays date minus snapshot date minus timediff is >0, then it's to old
	# Saves daily for 1 week, weekly for a month and monthly for a year
	diff=$(($date-$snapshotDate-$timediff))
	if [[ $diff -gt 0 ]]; then
		if zfs destroy $snapshot; then
			echo "$snapshot destroyed."
		else
			echo "Failed to destroy $snapshot"
		fi
	fi
done < $snapshots

# List remaining snapshots
echo ""
echo "Remaining $period snapshots"
zfs list -t snapshot | grep $period
echo "-----------------------------"

# Write to log once a week and every month
if [[ $period == "weekly" -o $period == "monthly" ]]; then
	cat $tempLog >> $log
fi

# Remove temporary files
rm $snapshots
rm $tempLog
