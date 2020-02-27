#!/bin/bash

defiface=$(/sbin/route -n | /usr/bin/awk '/^0.0.0.0/ { print $NF; exit; }')
myip=$(ip a s $defiface | awk '/inet / { split($2,a,"/"); print a[1]; exit; }')
grep "^interface ${defiface}" /etc/dhcpcd.conf &> /dev/null
RETVAL=$?

echo -n '{"status":"'
if [ $RETVAL -ne 0 ]; then
	echo -n DHCP enabled
else
	echo -n Static IP
fi

cat << EOF
", "payload":"<table width='100%'><tr><td><br /><strong>EV4RV Link:</strong></th><td align=right><a href='http://${myip}'>http://${myip}</a></td></tr></table>"}
EOF
