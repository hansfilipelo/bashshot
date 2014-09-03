#!/bin/bash

# If something fails - exit
set -e

# Variables
configFolder="/etc/bashshot"
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
cp $sourceFolder/bashshot.bash /usr/bin/
cp $sourceFolder/bashshot_cleaner.bash /usr/bin/
cp $sourceFolder/array /usr/bin/

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
  cp $sourceFolder/default-config $configFolder/bashshot.conf
fi

#--------------------
# Create crontab
if [[ -f $cronTabFolder/bashshot ]]
then
  echo "Crontab files exists, will not overwrite it."
else
  cp $sourceFolder/crontab $cronTabFolder/bashshot
fi

#---------------------------------------------------------
# Inform the user that the installation is complete
echo ""
echo "Installed bashShot succesfully!"

exit 0;
