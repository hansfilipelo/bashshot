
# Get array
. /usr/bin/array

# Starts snapshot cleaning
CLEANER=/usr/bin/bashshot_cleaner.sh
PERIOD=$(array 'frequently' 'hourly' 'daily' 'weekly' 'monthly')

#Decide which periods that is to be cleaned
if [[ $frequently == "yes" ]]
then
        PERIOD=$(array "$PERIOD" 'frequently')
fi

if [[ $hourly == "yes" && $(date '+%M') == "00" ]]
then
        PERIOD=$(array "$PERIOD" 'hourly')
fi

if [[ $daily == "yes" && $(date '+%H:%M') == "00:00" ]]
then
        PERIOD=$(array "$PERIOD" 'daily')
fi

if [[ $weekly == "yes" && $(date '+%u %H:%M') == "7 00:00" ]]
then
        PERIOD=$(array "$PERIOD" 'weekly')
fi

if [[ $monthly == "yes" && $(date '+%d %H:%M') == "01 00:00" ]]
then
        PERIOD=$(array "$PERIOD" 'monthly')
fi

echo $PERIOD | while IFS= read TIME
do
	# old script compatible with new verison but needs to run one time for each period
	$CLEANER $TIME
done

