#!/bin/bash

/usr/bin/grep -c "$(/usr/bin/curl --silent https://raw.githubusercontent.com/linuxkidd/ev4rv/master/revision)" revision &> /dev/null
echo -n $?
