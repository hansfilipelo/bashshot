#!/bin/bash

# If something fails - exit
set -e

# Check for zfs
if ! which zfs 1>/dev/null; then
  echo "ZFS not installed!"
  exit 1;
fi

# Check for cron
if ! which cron 1>/dev/null; then
  echo "cron not installed!"
  exit 1;
fi

# Directories.
# Note that the bashshot script has to be modified accordingly if you change configFolder.
configFolder="/usr/local/etc/bashshot"
# Note that the crontab must be modified accordingly if you change binaryFolder.
binaryFolder="/usr/local/bin"
cronTabFolder="/etc/cron.d"

# Change to the folder where the source code is located
sourceFolder=$( cd "$( dirname "$0" )" && pwd )
cd $sourceFolder

# Check if root
if [[ "$USER" != "root" ]]; then
  echo "Bashshot must be installed as root."
  sudo -u "root" -H $0 "$@"; exit;
fi

#---------------------------------------------------------

# Installing scripts
cp $sourceFolder/bashshot.bash $binaryFolder/bashshot
cp $sourceFolder/bashshot-cleaner.bash $binaryFolder/bashshot-cleaner

#---------------------------------------------------------

# Installing logrotate for /var/log/bashshot.log
touch /var/log/bashshot.log
cp $sourceFolder/logrotate /etc/logrotate.d/bashshot

# --------------------------
# Creates config
mkdir -p $configFolder
if [[ -f $configFolder/bashshot.conf ]]
then
  echo "Config files exists, will not overwrite it."
else
  # Creates config file
  cp $sourceFolder/config $configFolder/bashshot.conf
fi

#--------------------
# Create crontab
if [[ -f $cronTabFolder/bashshot ]]
then
  echo "Crontab exists, will not overwrite."
else
  cp $sourceFolder/crontab $cronTabFolder/bashshot
fi

#---------------------------------------------------------
# Inform the user that the installation is complete
echo ""
echo "Installed bashShot succesfully!"

exit 0;
