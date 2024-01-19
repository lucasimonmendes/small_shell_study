#!/bin/bash

PPA_PIPER_LIBRATG="ppa:libratbag-piper/piper-libratbag-git "
PPA_LUTRIS="ppa:lutris-team/lutris"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_SIMPLENOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"

PATH_DOWNLOADS_PROGRAMS="$HOME/Downloads/programas"


remove_locks () {
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

add_i386_architecture () {
 sudo dpkg --add-architecture i386 
}

update_repositories () {
  sudo apt update -y
}

add_ppas () {
  sudo apt-add-repository "$PPA_PIPER_LIBRATG" -y
  sudo add-apt-repository "$PPA_LUTRIS" -y
  update_repositories
}

install_debs () {
  mkdir "$PATH_DOWNLOADS_PROGRAMS"
  wget "$URL_GOOGLE_CHROME" -P "$PATH_DOWNLOADS_PROGRAMS"
  wget "$URL_SIMPLENOTE" -P    "$PATH_DOWNLOADS_PROGRAMS"
  sudo dpkg -i $PATH_DOWNLOADS_PROGRAMS/*.deb
  sudo apt -f install -y
}

install_apt_packages () {
  sudo apt install snapd -y
  sudo apt install winff -y
  sudo apt install guvcview -y
  sudo apt install virtualbox -y
}

install_snap_packages() {
  sudo snap install spotify
}

upgrade_and_clear_system () {
  sudo apt dist-upgrade -y
  sudo apt autoclean
  sudo apt autoremove -y
}


remove_locks
add_i386_architecture
add_ppas
install_apt_packages
install_snap_packages
upgrade_and_clear_system
