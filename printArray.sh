#!/bin/bash
myArray=(line1 4 56 78 90 23 end1)
#myArray=(How are you 123 456)
step=1
j=0
for i in "${myArray[@]}"
do
	let "j=$j+1"
	echo $j: $i
done
 
