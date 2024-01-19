#!/bin/bash

PPA_PIPER_LIBRATG="ppa:libratbag-piper/piper-libratbag-git "
PPA_LUTRIS="ppa:lutris-team/lutris"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_SIMPLENOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"

PATH_DOWNLOADS_PROGRAMS="$HOME/Downloads/programas"

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt-add-repository "$PPA_PIPER_LIBRATG" -y
sudo add-apt-repository "$PPA_LUTRIS" -y
sudo apt update -y
mkdir "$PATH_DOWNLOADS_PROGRAMS"
wget "$URL_GOOGLE_CHROME" -P "$PATH_DOWNLOADS_PROGRAMS"
wget "$URL_SIMPLENOTE" -P    "$PATH_DOWNLOADS_PROGRAMS"
sudo dpkg -i /home/lucas/Downloads/programas/*.deb
sudo apt -f install -y
sudo apt install snapd -y
sudo apt install winff -y
sudo apt install guvcview -y
sudo apt install virtualbox -y
sudo snap install spotify
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
