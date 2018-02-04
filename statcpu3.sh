#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)

PREV_TOTAL=0
PREV_IDLE=0
MAX=90

while true; do
	# Get the total CPU statistics, discarding the 'cpu ' prefix.
	CPU=($(cat "/proc/stat"))
	IDLE=${CPU[4]} # Just the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0
#	echo ${CPU[@]}	
	let "TOTAL=${CPU[1]}+${CPU[2]}+${CPU[3]}+${CPU[4]}"
#	echo -en "total: $TOTAL\n"	

	# Calculate the CPU usage since we last checked.
	let "DIFF_IDLE=$IDLE-$PREV_IDLE"
	let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
	let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
	echo -en "\b\b"
	echo -en "\rCPU: $DIFF_USAGE%"
	if [ "$DIFF_USAGE" -gt "$MAX" ]
	then
		echo -en " Heavy load "
		echo 1 > /sys/class/leds/beaglebone:green:usr0/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr1/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr2/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr3/brightness
		echo heavy load >> /var/log/syslog
	else
		echo -en " Light load "
		echo 0 > /sys/class/leds/beaglebone:green:usr0/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr1/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr2/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr3/brightness
		DATE=($(cat "/sys/class/rtc/rtc0/date"))
		TIME=($(cat "/sys/class/rtc/rtc0/time"))
		echo -en "${DATE[0]} " >> /var/log/syslog
		echo -en "${TIME[0]} " >> /var/log/syslog
		echo -en "light load\n" >> /var/log/syslog
	fi

	# Remember the total and idle CPU times for the next check.
	PREV_TOTAL="$TOTAL"
	PREV_IDLE="$IDLE"
	# Wait before checking again.
	sleep 1
done

