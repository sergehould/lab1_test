#!/bin/bash

LINE1=( $(cat "/home/list.txt") )
#LINE1=(`sed -n 's/^first\s//p' /home/list.txt`)
echo ${LINE1[@]}
echo -en "${LINE1[0]} ${LINE1[1]}"
echo ${LINE1[1]}
