#!/bin/sh
# Source of script: https://flodesign.co.uk/blog/simple-dos-mitigation-using-mod-evasive/
# Offending IP as detected by mod_evasive
IP=$1
BANTIME=$2

# Path to iptables binary executed by user www-data through sudo
IPTABLES="/sbin/iptables"

# mod_evasive lock directory
MOD_EVASIVE_LOGDIR=/var/log/mod_evasive

# Add the following firewall rule (block IP)
$IPTABLES -I INPUT -w -s $IP -j DROP

# Unblock offending IP after 2 hours through the 'at' command; see 'man at' for further details
echo "$IPTABLES -D INPUT -w -s $IP -j DROP" | at now + ${BANTIME:-2} minutes

# Remove lock file for future checks
rm -f "$MOD_EVASIVE_LOGDIR"/dos-"$IP"
