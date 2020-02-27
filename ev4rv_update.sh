#!/bin/bash

cd ~pi/ev4rv
git pull
RETVAL=$?

if [ $RETVAL -ne 0 ]; then
  echo Upgrade failed.  Please check your internet connection.
  exit 1
fi

unalias cp &> /dev/null
echo Upgrade complete.  Restarting, please wait...
sleep 5
/usr/bin/curl --data-binary @~pi/ev4rv/node-red/flows.json -H 'Content-Type: application/json' -H 'Node-RED-Deployment-Type: full' http://localhost:1880/flows > /dev/null
exit 0
