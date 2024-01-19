#!/bin/bash

PPA_PIPER_LIBRATG="ppa:libratbag-piper/piper-libratbag-git "
PPA_LUTRIS="ppa:lutris-team/lutris"

PATH_DOWNLOADS_PROGRAMS="$HOME/Downloads/programas"

DEB_PROGRAMS_TO_INSTALL=(
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb
)

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

if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo "[ERRO] - Seu computador não tem conexão com a internet. Verifique os cabos e o modem."
  exit 1
else
  echo "[INFO] - Conexão com a internet funcionando normalmente."
fi

if [[ ! -x `which wget` ]]; then
  echo "[INFO] wget não está instalado."
  echo "[INFO] Instalando wget."
  sudo apt install wget -y
else
  echo "[INFO] wget já está instalado."
fi


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
  for url in {$DEB_PROGRAMS_TO_INSTALL[@]}; do
    extracted_url=$(echo ${url##*/} | sed 's/-/_/g' | cut -d _ -f 1)
    if ! dpkg -l | grep -iq $extracted_url; then
      wget -c "$url" -P "$PATH_DOWNLOADS_PROGRAMS"
      sudo dpkg -i $PATH_DOWNLOADS_PROGRAMS/${url##*/}
    else
      echo "[INFO] - O programa $extracted_url já está instalado."
    fi
  done
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
