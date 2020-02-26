#!/bin/bash


unalias cp
cp ~pi/ev4rv/node-red/flows.json ~pi/.node-red/
sudo systemctl restart nodered
