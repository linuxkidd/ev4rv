#!/bin/bash

sudo apt update && sudo apt -y upgrade
sudo apt -y install mosquitto mosquitto-clients nginx git-core
sudo sed -i.bak -e 's/^persistence true$/persistence false/g' /etc/mosquitto/mosquitto.conf
sudo systemctl restart mosquitto

wget https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered
chmod 755 update-nodejs-and-nodered
./update-nodejs-and-nodered --confirm-install --confirm-pi
git clone https://github.com/linuxkidd/ev4rv.git
rsync -axHASP ev4rv/node-red/ .node-red/
sudo rsync -axHASP ev4rv/nginx/ /etc/nginx/
cd ~/.node-red/
npm install node-red-dashboard node-red-node-emoncms
sudo systemctl enable --now nodered

sudo rm -f /etc/nginx/sites-enabled/*
sudo ln -s /etc/nginx/sites-available/10-ev4rv.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
