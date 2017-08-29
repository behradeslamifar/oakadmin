#!/bin/bash

WHITELIST_FILE=/etc/whitelist_ip

if [ ! -f "$WHITELIST_FILE" ]
then
    echo "Find-dos cant find \"whitelist_ip\" file. Please create $WHITELIST_FILE file, to use this script"
    exit 1
fi

netstat -antp | grep EST | grep 80 | sort -k4n | awk '{print $5}' | sed 's/:[0-9]\{2,\}$//' | uniq -c | while read count ip 
do 
    if [ $count -ge 50 ] 
    then
	if grep -Fxq "$ip" $WHITELIST_FILE
	then
	    continue
	fi 
	/usr/local/sbin/ban_ip.sh $ip 60 
	logger -p daemon.warn "$ip blocked with $count concurrent request" 
    fi
done

exit 0
