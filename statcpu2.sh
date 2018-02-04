#!/bin/bash
# by Paul Colby (http://colby.id.au), no rights reserved ;)

PREV_TOTAL=0
PREV_IDLE=0
MAX=90

while true; do
	# Get the total CPU statistics, discarding the 'cpu ' prefix.
	CPU=(`sed -n 's/^cpu\s//p' /proc/stat`)
	IDLE=${CPU[3]} # Just the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0
	for VALUE in "${CPU[@]}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	# Calculate the CPU usage since we last checked.
	let "DIFF_IDLE=$IDLE-$PREV_IDLE"
	let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
	let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
	echo -en "\rCPU: $DIFF_USAGE%  \b\b"
	if [ "$DIFF_USAGE" -gt "$MAX" ]
	then
		echo -e "\nHeavy load"
		echo 1 > /sys/class/leds/beaglebone:green:usr0/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr1/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr2/brightness
		echo 1 > /sys/class/leds/beaglebone:green:usr3/brightness
		echo heavy load >> /var/log/syslog
	else
		echo -e "\nLight load"
		echo 0 > /sys/class/leds/beaglebone:green:usr0/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr1/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr2/brightness
		echo 0 > /sys/class/leds/beaglebone:green:usr3/brightness
		echo light load >> /var/log/syslog
	fi

	# Remember the total and idle CPU times for the next check.
	PREV_TOTAL="$TOTAL"
	PREV_IDLE="$IDLE"
	# Wait before checking again.
	sleep 1
done

