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
defgw=$(/sbin/route -n | awk '/^0.0.0.0/ { print $2 }')

cat << EOF
<table width='100%'>
<tr><td><strong>URL:</strong></th><td align=right><a href="http://${myip}">http://${myip}</a></td></tr>
<tr><td><strong>HotSpot URL:</strong></th><td align=right><a href="http://${defgw}">http://${defgw}</a></td></tr>
</table>
EOF
