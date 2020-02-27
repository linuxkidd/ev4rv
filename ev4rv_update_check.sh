#!/bin/bash

/usr/bin/grep -c "$(/usr/bin/curl --silent https://raw.githubusercontent.com/linuxkidd/ev4rv/master/revision)" revision &> /dev/null
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo -n 1
else
	echo -n 0
fi
