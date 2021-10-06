#!/bin/bash

# Script to perform local security checks



function checks() {
		if [[ $2 != $3 ]]
		then 
				echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is: $3.\e[0m"
		else 
	
				echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"
		
		fi 
}
# Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')

# Check for pass max
checks "Password Max Days" "365" "${pmax}"
 
# Check the pass min days between changes
 
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Pasword Min Days" "14" "${pmin}"

# Check the pass warn age

pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

# Check SSH UsePam configuration

chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePam" "yes" "${chkSSHPAM}"

# Check permission on users home directory

echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ' )  
do 
		chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ' )
		checks "Home directrory ${eachDir}" "drwx------" "${chDir}"
done

function check() {
		if [[ $2 != $3 ]]
		then 
				echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is: $3.\e[0m\nRemediation $4"
		else 
	
				echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"
		
		fi 
}

# Make sure the IP forwarding is disabled
chkIPfor=$( egrep -i "^#net.ipv4.ip_forward" /etc/sysctl.conf | awk '{print $3}')
check " IP forwarding" "0" "${chkIPfor}" "Edit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: \nsysctl -w"

# Check to see the ICMP redirects are not accepted
#chkICMPredir=$(egrep -i )
#check "ICMP Redirects" "0" "${chkICMPredir}" "\n	use command:\n		firewall-cmd --permanent --add-icmp-block=redirect --zone=public\n	This will block it from redirecting icmp's\n	Then make sure to use:\n		firewall-cmd --reload\n	This will finalize those#changes" 


# Ensure permission on /etc/crontab are configured

chkPermCron=$( ls -l /etc/crontab | awk ' { print $1 } ')
check "Permissions on /etc/crontab" "-rw-r--r--" "${chkPermCron}" "Use the command:\n	chown root:root /etc/crontab\nthen use\n	chmod og-rwk /etc/crontab"

# Ensure permission on /etc/cron.hourly are configured

chkPermCronh=$( ls -ld /etc/cron.hourly | awk ' { print $1 } ')
check "Permissions on /etc/cron.hourly" "drwx------" "${chkPermCronh}" "Use the command:\n	chown root:root /etc/cron.hourly\nthen use\n	chmod og-rwk /etc/cron.hourly"

# Ensure permission on /etc/cron.daily are configured

chkPermCrond=$( ls -ld /etc/cron.daily | awk ' { print $1 } ')
check "Permissions on /etc/cron.daily" "drwx------" "${chkPermCrond}" "Use the command:\n	chown root:root /etc/cron.daily\nthen use\n	chmod og-rwk /etc/cron.daily"

# Ensure permission on /etc/cron.weekly are configured

chkPermCronw=$( ls -ld /etc/cron.weekly | awk ' { print $1 } ')
check "Permissions on /etc/cron.weekly" "drwx------" "${chkPermCronw}" "Use the command:\n	chown root:root /etc/cron.weekly\nthen use\n	chmod og-rwk /etc/cron.weekly"

# Ensure permission on /etc/cron.monthly are configured

chkPermCronm=$( ls -ld /etc/cron.monthly | awk ' { print $1 } ')
check "Permissions on /etc/cron.monthly" "drwx------" "${chkPermCronm}" "Use the command:\n	chown root:root /etc/cron.monthly\nthen use\n	chmod og-rwk /etc/cron.monthly"

# Ensure permission on /etc/passwd are configured

chkPermPass=$( ls -l /etc/passwd | awk ' { print $1 } ')
check "Permissions on /etc/passwd" "-rw-r--r--" "${chkPermPass}" "Use the command:\n	chown root:root /etc/passwd\nthen use\n	chmod 644 /etc/passwd"

# Ensure permission on /etc/shadow are configured

chkPermShad=$( ls -l /etc/shadow | awk ' { print $1 } ')
check "Permissions on /etc/shadow" "-rw-r--r--" "${chkPermShad}" "Use the command:\n	chown root:root /etc/shadow\nthen use\n	chmod o-rwx,g-wx /etc/shadow"

# Ensure permission on /etc/group are configured

chkPermGroup=$( ls -l /etc/group | awk ' { print $1 } ')
check "Permissions on /etc/group" "-rw-r--r--" "${chkPermGroup}" "Use the command:\n	chown root:root /etc/group\nthen use\n	chmod 644 /etc/group"

# Ensure permission on /etc/gshadow are configured

chkPermGShad=$( ls -l /etc/group | awk ' { print $1 } ')
check "Permissions on /etc/gshadow" "-rw-r--r--" "${chkPermGShad}" "Use the command:\n	chown root:root /etc/gshadow\nthen use\n	chmod 0-rwx,g-rw /etc/gshadow"


# Ensure permission on /etc/passwd- are configured

chkPermPass-=$( ls -l /etc/passwd- | awk ' { print $1 } ')
check "Permissions on /etc/passwd-" "-rw-r--r--" "${chkPermPass-}" "Use the command:\n	chown root:root /etc/passwd-\nthen use\n	chmod u-x,go-wx /etc/passwd-"

# Ensure permission on /etc/shadow- are configured

chkPermShad-=$( ls -l /etc/shadow- | awk ' { print $1 } ')
check "Permissions on /etc/shadow-" "-rw-r--r--" "${chkPermShad-}" "Use the command:\n	chown root:root /etc/shadow-\nthen use\n	chmod o-rwx,g-rw /etc/shadow-"

# Ensure permission on /etc/group- are configured

chkPermGroup-=$( ls -l /etc/group- | awk ' { print $1 } ')
check "Permissions on /etc/group-" "-rw-r--r--" "${chkPermGroup-}" "Use the command:\n	chown root:root /etc/group-\nthen use\n	chmod u-x,go-wx /etc/group-"

# Ensure permission on /etc/gshadow- are configured

chkPermGShad-=$( ls -l /etc/group | awk ' { print $1 } ')
check "Permissions on /etc/gshadow-" "-rw-r--r--" "${chkPermGShad-}" "Use the command:\n	chown root:root /etc/gshadow-\nthen use\n	chmod 0-rwx,g-rw /etc/gshadow-"

