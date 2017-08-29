#!/bin/bash

netstat -antp | grep EST | grep 80 | sort -k4n | awk '{print $5}' | sed 's/:[0-9]\{2,\}$//' | uniq -c | while read count ip 
do 
	if [ $count -ge 100 ] 
	then
	    if [ "$ip" == "127.0.0.1" -o "$ip" == "172.20.20.30" ]
	    then
		continue
	    fi 
	    /usr/local/sbin/ban_ip.sh $ip 60 
	    logger -p daemon.warn "$ip blocked with $count concurrent request" 
	fi
done


