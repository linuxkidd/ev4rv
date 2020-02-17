#!/bin/bash

sudo apt update && sudo apt -y upgrade
sudo apt -y install mosquitto mosquitto-clients nodered nginx git-core
sudo sed -i.bak -e 's/^persistence true$/persistence false/g' /etc/mosquitto/mosquitto.conf
sudo systemctl restart mosquitto
sudo npm install -g npm
cd ~/.node-red/
npm install node-red-dashboard node-red-node-emoncms
curl -sL https://github.com/linuxkidd/ev4rv/archive/master.tar.gz | tar -C ~pi/.node-red -xv 
sudo systemctl enable --now nodered

cat <<'EOF' | sudo tee /etc/nginx/sites-available/10-ev4rv.conf
server {
    listen 80 default_server;
    root /var/www/html;
    server_name _;

    access_log off;
    error_log stderr crit;

    include /etc/nginx/snippets/php.conf;
    include /etc/nginx/snippets/emoncms.conf;


    # If / is requested, redirect the user to /ui/.
    location = / {
        return 302 /ui/;
    }

    # Forward all /ui requests to the node-red web server on port 1880.
    # Ensure websocket connections are handled correctly.
    location /ui {
        proxy_pass http://127.0.0.1:1880/ui;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

}
EOF

sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/10-ev4rv.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx