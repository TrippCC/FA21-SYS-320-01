#!/bin/bash

#Parse Apache lof
#
#101.236.44.127 - - [24/Oct/2017:04:11:14 -0500] "GET / HTTP/1.1" 200 225 "-" "Mozilla/5.0" "(Windows NT 6.2; WOW64) AppleWebKit/537. 36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36"

# Read in file


# Arguments using the postition, they start at $1
#APACHE_LOG="$1"
read -p "Please enter an apache log file: " APACHE_LOG
#check if file exists

if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to a log file"
	exit 1

fi


# Looking for web scanners
sed -e "s/\[//g" -e "s/\"//g"  ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
	printf format, "IP", "Date", "Method","Status", "Size", "URI"
	printf format, "--", "----", "------", "------", "----", "---"}

{ printf format, $1, $4, $6, $9, $10, $7 }'

#badIP="$( awk ' {print $1} ' ${APACHE_LOG} | sort | uniq )"

#echo "${badIP}\n"
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' access.log.txt | sort -u | tee badIPs.win
for eachIP in $(cat badIPs.win)
do
	echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachIP}\" dir=in action=block remoteip=${eachIP}" | tee -a badIPs.netsh

done
rm badIPs.win 
echo "Created IPTables for firewall drop rules in file \"badIPs.netsh\""
