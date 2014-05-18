
# Starts snapshot cleaning
CLEANER=/usr/bin/bashshot_cleaner.sh

# old script compatible with new verison but needs to run one time for each period
$CLEANER frequently
$CLEANER hourly
$CLEANER daily
$CLEANER weekly
$CLEANER monthly

