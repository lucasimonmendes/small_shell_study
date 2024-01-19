#!/bin/bash

# post_instalation_ubuntu.sh - Make the post configuration of Ubuntu 19.10
#  
# Author:        Lucas Simon
# Maintenance:   Lucas Simon
#
# ------------------------------------------------------------------------ #
# WHAT IT DOES?
# This script installs the programs I use after installation, upgrades and cleaning the system. 
# It is easy to expand (change variables).
#
# HOW TO USE IT?
# $ ./post_instalation_ubuntu.sh
#
# ------------------------------------------------------------------------ #
# Changelog:
#
#   v1.0 19/01/2024, Lucas Simon:
#     - First version with comments!
#
# ------------------------------------------------------------------------ #


# -------------------------------VARIABLES----------------------------------------- #
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

RED='\e[1;91m'
GREEN='\e[1;92m'
REMOVE_COLOR='\e[0m'
# ----------------------------------------------------------------------------- #

# -------------------------------TESTS----------------------------------------- #
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${RED}[ERRO] - Seu computador não tem conexão com a internet. Verifique os cabos e o modem.${REMOVE_COLOR}"
  exit 1
else
  echo -e "${GREEN}[INFO] - Conexão com a internet funcionando normalmente.${REMOVE_COLOR}"
fi

if [[ ! -x `which wget` ]]; then
  echo -e "${RED}[ERRO] - wget não está instalado.${REMOVE_COLOR}"
  echo -e "${GREEN}[INFO] - Instalando wget.${REMOVE_COLOR}"
  sudo apt install wget -y &> /dev/null
else
  echo -e "${GREEN}[INFO] - wget já está instalado.${REMOVE_COLOR}"
fi
# --------------------------------------------------------------------------------- #

# -------------------------------FUNCTIONS----------------------------------------- #
remove_locks () {
  echo -e "${GREEN}[INFO] - Removendo locks...${REMOVE_COLOR}"
  sudo rm /var/lib/dpkg/lock-frontend &> /dev/null
  sudo rm /var/cache/apt/archives/lock &> /dev/null
}

add_i386_architecture () {
 echo -e "{GREEN}[INFO] - Adicionando arquitetura i386...${REMOVE_COLOR}"
 sudo dpkg --add-architecture i386 &> /dev/null
}

update_repositories () {
  echo -e "${GREEN}[INFO] - Atualizando repositórios...${REMOVE_COLOR}"
  sudo apt update -y &> /dev/null
}

add_ppas () {
  echo -e "${GREEN}[INFO] - Adicionando PPAs...${REMOVE_COLOR}"
  sudo apt-add-repository "$PPA_PIPER_LIBRATG" -y &> /dev/null
  sudo add-apt-repository "$PPA_LUTRIS" -y &> /dev/null
  update_repositories
}

download_debs () {
  [[ ! -d "$PATH_DOWNLOADS_PROGRAMS" ]] && mkdir "$PATH_DOWNLOADS_PROGRAMS"
  for url in {$DEB_PROGRAMS_TO_INSTALL[@]}; do
    extracted_url=$(echo ${url##*/} | sed 's/-/_/g' | cut -d _ -f 1)
    if ! dpkg -l | grep -iq $extracted_url; then
      echo -e "${GREEN}[INFO] - Baixando arquivo $extracted_url...${REMOVE_COLOR}"
      wget -c "$url" -P "$PATH_DOWNLOADS_PROGRAMS" &> /dev/null
      echo -e "${GREEN}[INFO] - Instalando o $extracted_url...${REMOVE_COLOR}"
      sudo dpkg -i $PATH_DOWNLOADS_PROGRAMS/${url##*/} &> /dev/null

      echo -e "${GREEN}[INFO] - Instalando dependências...${REMOVE_COLOR}"
      sudo apt -f install -y &> /dev/null
    else
      echo -e "${GREEN}[INFO] - O programa $extracted_url já está instalado.${REMOVE_COLOR}"
    fi
  done
  }

install_apt_packages () {
  for program in ${APT_PROGRAMS_TO_INSTALL[@]}; do
    if ! dpkg -l | grep -q $program; then
      echo -e "${GREEN}[INFO] - Instalando o $program...${REMOVE_COLOR}"
      sudo apt install $program -y &> /dev/null
    else
      echo -e "${GREEN}[INFO] - O pacote $programa já está instalado.${REMOVE_COLOR}"
    fi
  done
}

install_snap_packages() {
  for program in ${SNAP_PROGRAMS_TO_INSTALL[@]}; do
    if ! snap list | grep -q $program; then
      echo -e "${GREEN}[INFO] - Instalando o $program...${REMOVE_COLOR}"
      sudo snap install $program &> /dev/null
    else
      echo -e "${GREEN}[INFO] - O pacote $programa já está instalado.${REMOVE_COLOR}"
    fi
  done
}

upgrade_and_clear_system () {
  echo -e "${GREEN}[INFO] - Fazendo limpeza e upgrade do sistema...${REMOVE_COLOR}"
  sudo apt dist-upgrade -y &> /dev/null
  sudo apt autoclean &> /dev/null
  sudo apt autoremove -y &> /dev/null
}
# ------------------------------------------------------------------------------- #

# -------------------------------EXECUTE----------------------------------------- #
remove_locks
add_i386_architecture
add_ppas
download_debs
install_apt_packages
install_snap_packages
upgrade_and_clear_system
# --------------------------------------------------------------------------------- #

