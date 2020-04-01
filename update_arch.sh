#!/bin/bash
# SCRIPT: update_arch.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script is a good way to update Arch without errors during the process.

clear
# --- default start ---------------------------
cd $(dirname "$0")                                  # goes to the script folder
source "default.sh"                                 # import default.sh
top() { title "UPDATE ARCH LINUX$lred!"; }; top     # show the title
# --- end of default start --------------------

# message that appears at the end of each step
finish() {
  echo -e "\n$lgreen YEAH!$gray \n"; sleep 2
}

# read news from: https://www.archlinux.org/feeds/news/
# you need to install and configure the 'newsboat' to this work
news() {
  line
  echo -e "\n$bold TIME TO READ ARCH LINUX UPDATE NEWS$reset$gray \n"
  echo -e " starting newsboat..$black ";
  if [ "$the_terminal" = "xfce4-terminal" ]; then
    xfce4-terminal --hide-menubar --hide-toolbar --hide-borders --geometry=70x34 -e "newsboat -r"
  else
    terminal "-e newsboat"
    echo -e "$gray press ""'r'"" to update the news on newsboat\n"
  fi
  echo -ne "$gray PAUSE TO READ (click to continue)"; read
  finish
}

# update unofficial ClamAV signatures
# see more at: https://wiki.archlinux.org/index.php/ClamAV
antivirus_up() {
  line
  echo -e "\n$bold UPDATING THE ANTIVIRUS$reset$gray \n"
  sudo freshclam
  sudo clamav-unofficial-sigs.sh
  finish
}

# delete files inside Yay and Pacman cache
cache_del() {
  line
  echo -e "\n$bold CLEANING YAY AND PACMAN CACHE$reset$gray \n"
  yes S | sudo yay -Scc
  finish
}

# update mirrorlist
# you need to install the 'reflector' program
mirrorlist_up() {
  line
  echo -e "\n$bold UPDATING THE MIRRORLIST$reset$gray \n"
  sudo reflector -l 10 --sort rate --completion-percent 100 -a 24 -p https -c Brazil -c Germany -c Czechia -c France -c Sweden -c 'United States' --save /etc/pacman.d/mirrorlist
  echo -e "\n$bold Update mirrorlist:$reset$gray \n"
  cat /etc/pacman.d/mirrorlist
  finish
}

# update repository keys
keys_up() {
  line
  echo -e "\n$bold UPDATING REPOSITORY KEYS$reset$gray \n"
  sudo pacman-key --init
  sudo pacman-key --populate
  #sudo pacman -S --noconfirm archlinux-keyring
  finish
}

# official repository update
# you need to install the 'yay' program
repository_up() {
  line
  echo -e "\n$bold UPDATING OFFICIAL REPOSITORY$reset$gray \n"
  yay -Syu --repo --noconfirm --cleanafter
  finish
}

# flatpak update
# you need to install the 'flatpak'
flatpak_up() {
  line
  echo -e "\n$bold UPDATING FLATPAK$reset$gray \n"
  sudo flatpak update --noninteractive
  finish
}

# snap update
# you need to install the 'snap'
snap_up() {
  line
  echo -e "\n$bold UPDATING SNAP$reset$gray \n"
  sudo snap refresh
  finish
}

# update the Arch User Repository
aur_up() {
  line
  echo -e "\n$bold UPDATING AUR$reset$gray \n"
  yay -Syu --aur --noconfirm --cleanafter
  finish
}

# update the pkgfile data
pkgfile_up() {
  line
  echo -e "\n$bold UPDATING PKGFILE$reset$gray \n"
  pkgfile -u
  finish
}

# ask if you want to restart the system
restart() {
  line
  echo -e "\n$bold THE END$reset$gray \n"
  read -p " Do you want to restart the system (y/n)? " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    finish
    reboot
  fi
  exit
}

# MENU ITEM
Update_all_the_system/menu() {
  sudo echo && finish
  news
  antivirus_up
  cache_del
  mirrorlist_up
  keys_up
  repository_up
  flatpak_up
  snap_up
  aur_up
  pkgfile_up
  restart
}

# MENU ITEM
Update_only_the_oficial_repository/menu() {
  sudo echo && finish
  news
  cache_del
  mirrorlist_up
  keys_up
  repository_up
  restart
}

# MENU ITEM
Update_only_the_AUR/menu() {
  sudo echo && finish
  news
  cache_del
  mirrorlist_up
  keys_up
  aur_up
  restart
}

echo
while :; do           # infinite menu loop
  echo -e "$gray "
  fmenu               # create the network menu
  clear
  top
done
