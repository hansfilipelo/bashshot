#!/bin/bash
# If something fails - exit

# Check if root
if [[ whoami -ne "root" ]]; then
	echo "Must be root to run this installer."
	exit 1;
fi

# Removes bashShot from crontab
rm /etc/cron.d/bashshot

# Removes scripts
rm /usr/bin/bashshot.sh
rm /usr/bin/bashshot_cleaner.sh
rm /usr/bin/array

if [[ $1 == purge ]]
then
	# Removes configuration
	rm -r /etc/bashshot
fi

# Removes file for log rotation
rm /etc/logrotate.d/bashshot

# Removes logfile
rm /var/log/bashshot.log

