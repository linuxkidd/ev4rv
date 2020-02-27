#!/bin/bash

defiface=$(/sbin/route -n | /usr/bin/awk '/^0.0.0.0/ {print $NF}')
echo Setting $defiface to IP address $(/sbin/ip a s $defiface | /usr/bin/awk '/inet / { print $2 }')...
(
cat <<EOF
hostname
clientid
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option interface_mtu
require dhcp_server_identifier
slaac private

EOF

echo interface $defiface
/sbin/ip a s $defiface | /usr/bin/awk '/inet / { print "static ip_address="$2 }'
/sbin/route -n | /usr/bin/awk '/^0.0.0.0/ {printf("static routers=%s\n",$2)}'
echo domain_name_servers=1.1.1.1 1.0.0.1
) | sudo tee /etc/dhcpcd.conf &> /dev/null
echo Done
