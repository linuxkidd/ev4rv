#!/bin/bash

cd ~pi/ev4rv
git remote update &> /dev/null && git status | grep 'git pull' &> /dev/null
echo -n $?
