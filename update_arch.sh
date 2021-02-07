#!/bin/bash
# SCRIPT: update_arch.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: This script is an easy way to update Arch Linux.

# For this script to work it is necessary to have 'default.sh' in the same folder.

clear
# --- default start ---------------------------
cd $(dirname "$0")                                                    # goes to the script folder
source "default.sh"                                                   # import default.sh
top() { title "UPDATE AND MAINTENANCE OF ARCH LINUX$lred!"; }; top    # show the title
# --- end of default start --------------------

# stylized message
message() {
echo -e "\n$bold $1$reset$gray \n"
}

# message that appears at the end of each step
finish() {
  echo -e "\n$lgreen YEAH!$gray \n"; sleep 2
}

# read news from: https://www.archlinux.org/feeds/news/
# you need to install and configure the 'newsboat' to this work
news() {
  line
  message "TIME TO READ ARCH LINUX UPDATE NEWS"
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
  message "UPDATING THE ANTIVIRUS"
  sudo freshclam
  sudo clamav-unofficial-sigs.sh
  finish
}

# delete files inside Paru and Pacman cache
paru_pacman_cache_del() {
  line
  message "CLEANING PARU AND PACMAN CACHE"
  yes S | paru -Scc
  finish
}

# clear trash
clear_trash() {
  line
  message "CLEANING THE TRASH"
  trash-empty 2
  finish
}

# delete everything inside the cache folder in the user's directory
del_cache_folder() {
  line
  message "CLEANING CACHE FOLDER IN $HOME"
  echo "Size:"
  du -sh ~/.cache/
  echo -e "\nCleaning..."
  rm -rf ~/.cache/*
  finish
}

# clear yarn and npm cache
clear_yarn_and_npm_cache() {
  line
  message "CLEANING YARN AND NPM CACHE"
  yarn cache clean
  npm cache clean --force
  finish
}

# update mirrorlist
# you need to install the 'reflector' program
mirrorlist_up() {
  line
  message "UPDATING THE MIRRORLIST"
  sudo reflector -l 10 --sort rate --completion-percent 100 -a 24 -p https --save /etc/pacman.d/mirrorlist
  message "Update mirrorlist:"
  cat /etc/pacman.d/mirrorlist
  finish
}

# update repository keys
keys_up() {
  line
  message "UPDATING REPOSITORY KEYS"
  sudo pacman-key --init
  sudo pacman-key --populate
  #sudo pacman -S --noconfirm archlinux-keyring
  finish
}

# official repository update
# you need to install the 'paru' program
repository_up() {
  line
  message "UPDATING OFFICIAL REPOSITORY"
  yes S | paru -Syu --repo --cleanafter
  # paru -Syu --repo --noconfirm --cleanafter
  finish
}

# flatpak update
# you need to install the 'flatpak'
flatpak_up() {
  line
  message "UPDATING FLATPAK"
  sudo flatpak update --noninteractive
  finish
}

# snap update
# you need to install the 'snap'
snap_up() {
  line
  message "UPDATING SNAP"
  sudo snap refresh
  finish
}

# update the Arch User Repository
aur_up() {
  line
  message "UPDATING AUR"
  yes S | paru -Syu --aur --cleanafter
  # paru -Syu --aur --noconfirm --cleanafter
  finish
}

# update the pkgfile data
pkgfile_up() {
  line
  message "UPDATING PKGFILE"
  pkgfile -u
  finish
}

# remove unneeded packages (orphans)
orphans() {
  line
  message "REMOVING UNNEEDED PACKAGES (ORPHANS)"
  yes S | paru --clean
  finish
}

# ask if you want to restart the system
restart() {
  line
  message "THE END"
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
  paru_pacman_cache_del
  mirrorlist_up
  keys_up
  repository_up
  flatpak_up
  snap_up
  aur_up
#  pkgfile_up
  orphans
  restart
}

# MENU ITEM
Update_only_the_oficial_repository/menu() {
  sudo echo && finish
  news
  paru_pacman_cache_del
  mirrorlist_up
  keys_up
  repository_up
  orphans
  restart
}

# MENU ITEM
Update_only_the_AUR/menu() {
  sudo echo && finish
  news
  paru_pacman_cache_del
  mirrorlist_up
  keys_up
  aur_up
  orphans
  restart
}

# MENU ITEM
Clean_the_system/menu() {
  sudo echo && finish
  clear_trash
  del_cache_folder
  paru_pacman_cache_del
  clear_yarn_and_npm_cache
}

echo
while :; do           # infinite menu loop
  echo -e "$gray "
  fmenu2              # create the menu
  clear
  top
done
