#!/bin/bash

PPA_PIPER_LIBRATG="ppa:libratbag-piper/piper-libratbag-git "
PPA_LUTRIS="ppa:lutris-team/lutris"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_SIMPLENOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"

PATH_DOWNLOADS_PROGRAMS="$HOME/Downloads/programas"

APT_PROGRAMS_TO_INSTALL=(
  snapd
  winff
  guvcview
  virtualbox
)

SNAP_PROGRAMS_TO_INSTALL=(
  spotify
  postman
)

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

download_debs () {
  [[ ! -d "$PATH_DOWNLOADS_PROGRAMS" ]] && mkdir "$PATH_DOWNLOADS_PROGRAMS"
  wget "$URL_GOOGLE_CHROME" -P "$PATH_DOWNLOADS_PROGRAMS"
  wget "$URL_SIMPLENOTE" -P    "$PATH_DOWNLOADS_PROGRAMS"
  }

install_debs () {
  sudo dpkg -i $PATH_DOWNLOADS_PROGRAMS/*.deb
  sudo apt -f install -y
}

install_apt_packages () {
  for program in ${APT_PROGRAMS_TO_INSTALL[@]}; do
    if ! dpkg -l | grep -q $program; then
      sudo apt install $program -y
    else
      echo "[INFO] - O pacote $programa já está instalado."
    fi
  done
}

install_snap_packages() {
  for program in ${SNAP_PROGRAMS_TO_INSTALL[@]}; do
    if ! snap list | grep -q $program; then
      sudo snap install $program
    else
      echo "[INFO] - O pacote $programa já está instalado."
    fi
  done
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
