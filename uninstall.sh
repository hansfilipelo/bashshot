#!/bin/bash
# If something fails - exit

# Check if root
if [[ whoami -ne "root" ]]; then
	echo "Must be root to run this installer."
	exit 1;
fi

# Removes bashShot from crontab
rm -f /etc/cron.d/bashshot

# Removes scripts
rm -f /usr/bin/bashshot.sh
rm -f /usr/bin/bashshot_cleaner.sh
rm -f /usr/bin/array

if [[ $1 == purge ]]
then
	# Removes configuration
	rm -rf /etc/bashshot
fi

# Removes file for log rotation
rm -f /etc/logrotate.d/bashshot

# Removes logfile
rm -f /var/log/bashshot.log

