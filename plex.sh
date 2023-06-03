#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install unzip socat libexpat1 apt-transport-https -y

sudo apt install wget software-properties-common -y

curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo gpg --dearmor -o /etc/apt/keyrings/plex.gpg

echo "deb [signed-by=/etc/apt/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

sudo apt update

sudo apt install plexmediaserver -y
