#!/bin/bash

sudo apt update && sudo apt -y upgrade
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo There was an error upgrading local packages.  Please run $0 again.
	exit 1
fi
sudo apt -y install mosquitto mosquitto-clients nginx git-core
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo There was an error installing needed packages.  Please run $0 again.
	exit 1
fi

sudo sed -i.bak -e 's/^persistence true$/persistence false/g' /etc/mosquitto/mosquitto.conf
sudo systemctl restart mosquitto

wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo There was an error downloading NodeRED install script.  Please re-run $0 again.
	exit 1
fi
chmod 755 update-nodejs-and-nodered
./update-nodejs-and-nodered --confirm-install --confirm-pi
if [ -e ~pi/ev4rv ]; then
	cd ~pi/ev4rv
	git pull
	RETVAL=$?
	if [ $RETVAL -ne 0 ]; then
		echo There was an error downloading EV4RV code.  Please re-run $0 again.
		exit 1
	fi
	cd ~pi
else
	git clone https://github.com/linuxkidd/ev4rv.git
	RETVAL=$?
	if [ $RETVAL -ne 0 ]; then
		echo There was an error downloading EV4RV code.  Please re-run $0 again.
		exit 1
	fi
fi
rsync -axHASP ev4rv/node-red/ .node-red/
sudo rsync -axHASP ev4rv/nginx/ /etc/nginx/
cd ~/.node-red/
npm install node-red-dashboard node-red-node-emoncms
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
	echo There was an error installing needed NodeRED nodes.  Please re-run $0 again.
	exit 1
fi

sudo systemctl enable --now nodered

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /etc/nginx/sites-available/10-ev4rv.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
