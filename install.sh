#!/bin/bash

# If something fails - exit
set -e

# Sets hour of day to snapshot
echo ""
echo "Enter hour of day (two digits, i e 03 for 3 am) to take daily, weekly and monthly snapshots:"
echo "----------------------"
read HOUR

#---------------------------------------------------------

MINUTE=banan
# Sets minute of hour for when to start take daily, weekly and monthly
echo ""
echo "Enter minute of hour (two digits, i e 03 for 3 am) to take daily, weekly and monthly snapshots. Do not enter 00,15,30 or 45 since frequent snapshots run at that time."
echo "----------------------"
while read MINUTE
do
	if [ -z $MINUTE ]
	then
		echo ""
		echo "Enter minute of hour (two digits, i e 03 $(echo $HOUR):03) to take daily, weekly and monthly snapshots.
		echo "----------------------"
	else
		break
	fi
done

#---------------------------------------------------------

# Sets installmode
echo ""
echo "Enter options for installation or leave empty for default. Available options are:"
echo "	nofrequently	nodaily"
echo "----------------------"
read INSTALLTYPE

if [ -z $INSTALLTYPE ]
then
	INSTALLTYPE=default
fi

#--------------------------------------------------------- 

# cd to script dir
DIR=$( cd "$( dirname "$0" )" && pwd )
cd $DIR

# Installing scripts
cp $DIR/bashshot.sh /usr/bin/
cp $DIR/bashshot_cleaner.sh /usr/bin/

#---------------------------------------------------------
# Creates configfolder
mkdir -p /etc/bashshot

# Creates file with FS to snapshot
FILESYSTEMS=/etc/bashshot/filesystems.list
touch $FILESYSTEMS

echo ""
echo 'Enter a filesystem to snapshot (i e "pool/filesystem") - write "done" without quotation marks when finished:'
echo "----------------------"
while read FS
do
	if [ -z $FS ]
	then
		break
	elif [ $FS == done ]
	then
		break
	else
		echo $FS >> $FILESYSTEMS
		echo ""
		echo "Filesystems added to bashShot config file:"
		while read line
		do
			echo $line
		done < $FILESYSTEMS
		echo ""
		echo 'Enter a filesystem to snapshot (i e "pool/filesystem") - write "done" without quotation marks when finished:'
		echo "----------------------"	
	fi
done

#---------------------------------------------------------

# Gets crontab
CRONTAB=$DIR/mycron
crontab -l > $CRONTAB

echo ""
echo "----------------------"
echo "Bashshot will run at:"
echo "$HOUR:10 for daily,"
echo "$HOUR:15 for weekly,"
echo "and $HOUR:20 for monthly snapshots"

# --------------------------

# Installing logrotate for /var/log/bashshot.log
touch /var/log/bashshot.log
touch /etc/logrotate.d/bashshot

cat $DIR/logrotate.txt > /etc/logrotate.d/bashshot

# --------------------------

if [ $INSTALLTYPE == nofrequently ]
then
	echo "No frequent (frequently+hourly) snapshots will be taken)."
	echo "" >> $CRONTAB
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "$MINUTE $HOUR * * * /usr/bin/bashshot.sh daily" >> $CRONTAB
	echo "$(($MINUTE+1)) $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "$((MINUTE+2)) $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "$((MINUTE+3)) $HOUR * * * /usr/bin/bashshot_cleaner.sh daily" >> $CRONTAB
	echo "$((MINUTE+4)) $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "$((MINUTE+5)) $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
elif [ $INSTALLTYPE == nodaily ]
then
	echo "No daily (frequently+hourly+daily) snapshots will be taken."
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "$MINUTE $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "$((MINUTE+1)) $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "$((MINUTE+2)) $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "$((MINUTE+3)) $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
elif [ $INSTALLTYPE == default ]
then
	echo "Bashshot will run with time-slider-like functionality."
	echo "# Bashshot - Solaris time-slider-like functionality for GNU/Linux implemented in bash" >> $CRONTAB
	echo "0,15,30,45 * * * * /usr/bin/bashshot.sh frequently" >> $CRONTAB
	echo "5 * * * * /usr/bin/bashshot.sh hourly" >> $CRONTAB
	echo "$MINUTE $HOUR * * * /usr/bin/bashshot.sh daily" >> $CRONTAB
	echo "$((MINUTE+1)) $HOUR * * 0 /usr/bin/bashshot.sh weekly" >> $CRONTAB
	echo "$((MINUTE+2)) $HOUR 1 * * /usr/bin/bashshot.sh monthly" >> $CRONTAB
	echo "# Cleaner scripts" >> $CRONTAB
	echo "1,16,31,46 * * * * /usr/bin/bashshot_cleaner.sh frequently" >> $CRONTAB
	echo "$((MINUTE+3)) * * * * /usr/bin/bashshot_cleaner.sh hourly" >> $CRONTAB
	echo "$((MINUTE+4)) $HOUR * * * /usr/bin/bashshot_cleaner.sh daily" >> $CRONTAB
	echo "$((MINUTE+5)) $HOUR * * 0 /usr/bin/bashshot_cleaner.sh weekly" >> $CRONTAB
	echo "$((MINUTE+6)) $HOUR 1 * * /usr/bin/bashshot_cleaner.sh monthly" >> $CRONTAB
	echo ""
else
	echo ""
	echo "Install failed - invalid install type."
	exit
fi

# Sets crontab
crontab $CRONTAB
rm $CRONTAB

#---------------------------------------------------------

echo ""
echo "Installed bashShot succesfully!"