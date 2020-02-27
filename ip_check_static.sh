#!/bin/bash

defiface=$(/sbin/route -n | /usr/bin/awk '/^0.0.0.0/ { print $NF }')
myip=$(ip a s $defiface | awk '/inet / { split($2,a,"/"); print a[1]; exit; }')
grep "^interface ${defiface}" /etc/dhcpcd.conf &> /dev/null
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo -n DHCP enabled
else
	echo -n Static IP
fi
echo , URL: \<a href="http://${myip}"\>http://${myip}\</a\>
