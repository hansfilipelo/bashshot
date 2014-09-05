#!/bin/bash

# Check if root
if [[ "$USER" != "root" ]]; then
  echo "Bashshot must be run as root."
  sudo -u "root" -H $0 "$@"; exit;
fi

# cd to script dir
cd "$( dirname "$0" )"

# Gets date and filesystems (FS) from config file
. /usr/local/etc/bashshot/bashshot.conf
date=$(date '+%Y-%m-%d_%H:%M')
logPath=/var/log/bashshot.log

# Creates temporary file which will be sent to logfile
tempLogPath=/tmp/log.txt
touch $tempLogPath

# Decide which periods that is to be snapshoted
if [[ $frequently == "yes" ]]; then
  period="$period frequently"
fi

if [[ $hourly == "yes" && $(date '+%M' == "00") ]]; then
  period="$period hourly"
fi

if [[ $daily == "yes" && $(date '+%H:%M') == "00:00" ]]; then
  period="$period daily"
fi

if [[ $weekly == "yes" && $(date '+%u %H:%M') == "7 00:00" ]]; then
  period="$period weekly"
fi

if [[ $monthly == "yes" && $(date '+%d %H:%M') == "01 00:00" ]]; then
  period="$period monthly"
fi

# Writes if debug set
if [[ $1 == "DEBUG" ]]; then
  echo "DEBUG: Periods to snapshot"
  for element in $period; do
    echo "$element"
  done
fi

# Echos stuff
echo ""
echo "Written by bashshot.sh"
echo "-------------------------"
date "+%Y-%m-%d %H:%M"

#Loops through periods to run
for time in $period; do
  # Loops through FS to snapshot, but skip empty
  for fs in $filesystems;	do
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
if [[ $1 != "DEBUG"  ]]; then
  cat $tempLogPath >> $logPath
fi

#Removes temporary log file
rm $tempLogPath

exit 0;
