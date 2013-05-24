#!/bin/bash

# If something fails - exit
set -e

# Sets hour of day to snapshot
echo ""
echo "Enter hour of day to take daily, weekly and monthly snapshots:"
read HOUR

# Sets installmode
echo ""
echo "Enter options for installation or leave empty for default. Available options are:"
echo "	nofrequently	nodaily"
read INSTALLTYPE

if [ -z $INSTALLTYPE ]
then
	INSTALLTYPE=default
fi

# Sets flag for install 

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Installing scripts
cp $DIR/bashshot.sh /usr/bin/
cp $DIR/bashshot_cleaner.sh /usr/bin/

# -----------------------------------------
# Creates configfolder
mkdir -p /etc/bashshot

# Creates file with FS to snapshot
FILESYSTEMS=/etc/bashshot/filesystems.list
touch $FILESYSTEMS

FS=1
for [ -n $FS ]
do
	echo ""
	echo "Enter a filesystem to snapshot - leave empty when you entered all filesystems:"
	read FS
	if [ -n $FS ]
	then
		echo $FS >> $FILESYSTEMS
	fi
done

# -----------------------------------------

# Gets crontab
CRONTAB=$DIR/mycron
crontab -l > $CRONTAB

echo "Bashshot will run at:"
echo "$HOUR:10 for daily,"
echo "$HOUR:15 for weekly,"
echo "and $HOUR:20 for monthly snapshots"

if [ $INSTALLTYPE == nofrequently ]
then
	echo "No frequent (frequently+hourly) snapshots will be taken)."
	echo "" >> $CRONTAB
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "10 $HOUR * * * /usr/bin/bashshot.sh daily" >> $CRONTAB
	echo "15 $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "20 $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "40 $HOUR * * * /usr/bin/bashshot_cleaner.sh daily" >> $CRONTAB
	echo "50 $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "55 $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
elif [ $INSTALLTYPE == nodaily ]
then
	echo "No daily (frequently+hourly+daily) snapshots will be taken."
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "15 $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "20 $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "50 $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "55 $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
elif [ $INSTALLTYPE == default ]
then
	echo "Bashshot will run with time-slider-like functionality."
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "0,15,30,45 * * * * /usr/bin/bashshot.sh frequently" >> $CRONTAB
	echo "5 * * * * /usr/bin/bashshot.sh hourly" >> $CRONTAB
	echo "10 $HOUR * * * /usr/bin/bashshot.sh daily" >> $CRONTAB
	echo "15 $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "20 $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "1,16,31,46 * * * * /usr/bin/bashshot_cleaner.sh frequently" >> $CRONTAB
	echo "6 * * * * /usr/bin/bashshot_cleaner.sh hourly" >> $CRONTAB
	echo "40 $HOUR * * * /usr/bin/bashshot_cleaner.sh daily" >> $CRONTAB
	echo "50 $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "55 $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
else
	echo "Install failed - invalid install type."
	exit
fi

# Sets crontab
crontab $CRONTAB
rm $CRONTAB

