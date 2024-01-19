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
  sudo apt install wget -y &> /dev/null
else
  echo "[INFO] wget já está instalado."
fi


remove_locks () {
  echo "[INFO] - Removendo locks..."
  sudo rm /var/lib/dpkg/lock-frontend &> /dev/null
  sudo rm /var/cache/apt/archives/lock &> /dev/null
}

add_i386_architecture () {
 echo "[INFO] - Adicionando arquitetura i386..."
 sudo dpkg --add-architecture i386 &> /dev/null
}

update_repositories () {
  echo "[INFO] - Atualizando repositórios..."
  sudo apt update -y &> /dev/null
}

add_ppas () {
  echo "[INFO] - Adicionando PPAs..."
  sudo apt-add-repository "$PPA_PIPER_LIBRATG" -y &> /dev/null
  sudo add-apt-repository "$PPA_LUTRIS" -y &> /dev/null
  update_repositories
}

download_debs () {
  [[ ! -d "$PATH_DOWNLOADS_PROGRAMS" ]] && mkdir "$PATH_DOWNLOADS_PROGRAMS"
  for url in {$DEB_PROGRAMS_TO_INSTALL[@]}; do
    extracted_url=$(echo ${url##*/} | sed 's/-/_/g' | cut -d _ -f 1)
    if ! dpkg -l | grep -iq $extracted_url; then
      echo "[INFO] - Baixando arquivo $extracted_url..."
      wget -c "$url" -P "$PATH_DOWNLOADS_PROGRAMS" &> /dev/null
      echo "[INFO] - Instalando o $extracted_url..."
      sudo dpkg -i $PATH_DOWNLOADS_PROGRAMS/${url##*/} &> /dev/null

      echo "[INFO] - Instalando dependências..."
      sudo apt -f install -y &> /dev/null
    else
      echo "[INFO] - O programa $extracted_url já está instalado."
    fi
  done
  }

install_apt_packages () {
  for program in ${APT_PROGRAMS_TO_INSTALL[@]}; do
    if ! dpkg -l | grep -q $program; then
      echo "[INFO] - Instalando o $program..."
      sudo apt install $program -y &> /dev/null
    else
      echo "[INFO] - O pacote $programa já está instalado."
    fi
  done
}

install_snap_packages() {
  for program in ${SNAP_PROGRAMS_TO_INSTALL[@]}; do
    if ! snap list | grep -q $program; then
      echo "[INFO] - Instalando o $program..."
      sudo snap install $program &> /dev/null
    else
      echo "[INFO] - O pacote $programa já está instalado."
    fi
  done
}



upgrade_and_clear_system () {
  echo "[INFO] - Fazendo limpeza e upgrade do sistema..."
  sudo apt dist-upgrade -y &> /dev/null
  sudo apt autoclean &> /dev/null
  sudo apt autoremove -y &> /dev/null
}


remove_locks
add_i386_architecture
add_ppas
download_debs
install_apt_packages
install_snap_packages
upgrade_and_clear_system
