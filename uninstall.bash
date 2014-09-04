#!/bin/bash
# If something fails - exit
set -e

# Check if the user is root
if [[ "$USER" != "root" ]]; then
  echo "You must be root to uninstall bashshot."
  sudo -u "root" -H $0 "$@"; exit;
fi

# Removes bashShot from crontab
rm -f /etc/cron.d/bashshot

# Removes scripts
rm -f /usr/local/bin/bashshot
rm -f /usr/local/bin/bashshot-cleaner

if [[ $1 == purge ]]
then
	# Removes configuration
	rm -rf /usr/local/etc/bashshot
fi

# Removes file for log rotation
rm -f /etc/logrotate.d/bashshot

# Removes logfile
rm -f /var/log/bashshot.log
