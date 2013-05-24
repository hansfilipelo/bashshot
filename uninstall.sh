#!/bin/bash

set -e

# Removes bashShot from crontab
MYCRON=/tmp/mycron.txt
(crontab -l | grep -iv bashshot | grep -iv "cleaner scripts") > $MYCRON
crontab $MYCRON

# Removes scripts
rm /usr/bin/bashshot.sh
rm /usr/bin/bashshot_cleaner.sh

# Removes configuration
rm -r /etc/basshot