#!/bin/bash

# TODO interface select, sound alarm

MAC=$1
FREQ5=$2
IFACE=wlan0
FILE=/tmp/$RANDOM

echo -e "\033[01;97m"
echo '
              .-  _           _  -.
             /   /             \   \
            (   (  (` (-o-) `)  )   )
             \   \_ `  -+-  ` _/   /
              `-       -+-       -`
                       -+-
                       _|_
	        ____  _____ _____ 
	       |    \|     |     |
	       |  |  | | | |   --|
	       |____/|_|_|_|_____|

'
echo '	  DMC - Decibel-Meter Converter'
echo -e "\e[0m"
echo 

if [[ ! "$MAC" ]]
then
	echo 'Usage : dmc MAC (5GHz)'
	exit 1
fi

#/etc/init.d/network-manager stop
#killall wpa_supplicant
airmon-ng check kill
# these processes could mess up the sniffing

if [[ "$FREQ5" ]]
then
	airodump-ng $IFACE -b a -w $FILE --output-format csv &>/dev/null &
else
	airodump-ng $IFACE -w $FILE --output-format csv &>/dev/null &
fi

sleep 5

while true
do
	dbm=$(grep -i "$MAC" $FILE-01.csv | tail -n 1 | cut -d ',' -f 4 | tr -d ' -')
	if [[ "$dbm" ]]
	then
		if [[ "$FREQ5" ]]
		then
			python -c "from math import log10 ; print(round(10 ** (( 27.55 - (20 * log10(5200)) + $dbm ) / 20 ),2))"
		else
			python -c "from math import log10 ; print(round(10 ** (( 27.55 - (20 * log10(2500)) + $dbm ) / 20 ),2))"
		fi
# for more details - https://gist.github.com/cryptolok/516471ce35a9851197b204853c6de080
	fi
	sleep 10
# 10 seconds is the optimal time interval between measurements based on my cases
done

