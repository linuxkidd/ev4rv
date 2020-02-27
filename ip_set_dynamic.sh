#!/bin/bash

echo Removing all static IP settings...

cat <<EOF | sudo tee /etc/dhcpcd.conf > /dev/null
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

echo Done
