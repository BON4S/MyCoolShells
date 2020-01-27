#!/bin/bash
# SCRIPT: update_arch.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script is a good way to update Arch without errors during the process.

clear
# --- default start ---
cd $(dirname "$0")                # goes to the script folder
source "header.sh"                # import header.sh
Top() {
  Title "UPDATE ARCH LINUX$lred!"
} && Top                          # show the title
# --- end of default start ---

# message that appears at the end of each step
Finish() {
  echo -e "\n$lgreen YEAH!$gray \n"; sleep 2
}

# read news from: https://www.archlinux.org/feeds/news/
# you need to install and configure the 'newsboat' to this work
UpdateNews() {
  Line
  echo -e "\n$bold TIME TO READ ARCH LINUX UPDATE NEWS$reset$gray \n"
  echo -e " starting newsboat..$black ";
  if [ "$terminal" = "xfce4-terminal" ]; then
    xfce4-terminal --hide-menubar --hide-toolbar --hide-borders --geometry=70x34 -e "newsboat -r"
  else
    Terminal "-e newsboat"
    echo -e "$gray press ""'r'"" to update the news on newsboat\n"
  fi
  echo -ne "$gray PAUSE TO READ (click to continue)"; read
  Finish
}

# update unofficial ClamAV signatures
# see more at: https://wiki.archlinux.org/index.php/ClamAV
UpdateAntivirus() {
  Line
  echo -e "\n$bold UPDATING THE ANTIVIRUS$reset$gray \n"
  sudo freshclam
  sudo clamav-unofficial-sigs.sh
  Finish
}

# delete files inside Yay and Pacman cache
ClearCache() {
  Line
  echo -e "\n$bold CLEANING YAY AND PACMAN CACHE$reset$gray \n"
  yes S | sudo yay -Scc
  Finish
}

# update mirrorlist
# you need to install the 'reflector' program
MirrorlistUpdate() {
  Line
  echo -e "\n$bold UPDATING THE MIRRORLIST$reset$gray \n"
  sudo reflector -l 10 --sort rate --completion-percent 100 -a 24 -p https -c Brazil -c Germany -c Czechia -c France -c Sweden -c 'United States' --save /etc/pacman.d/mirrorlist
  echo -e "\n$bold Update mirrorlist:$reset$gray \n"
  cat /etc/pacman.d/mirrorlist
  Finish
}

# update repository keys
KeysUpdate() {
  Line
  echo -e "\n$bold UPDATING REPOSITORY KEYS$reset$gray \n"
  sudo pacman-key --init
  sudo pacman-key --populate
  #sudo pacman -S --noconfirm archlinux-keyring
  Finish
}

# official repository update
# you need to install the 'yay' program
OfficialRepositoryUpdate() {
  Line
  echo -e "\n$bold UPDATING OFFICIAL REPOSITORY$reset$gray \n"
  yay -Syu --repo --noconfirm --cleanafter
  Finish
}

# flatpak update
# you need to install the 'flatpak'
FlatpakUpdate() {
  Line
  echo -e "\n$bold UPDATING FLATPAK$reset$gray \n"
  sudo flatpak update --noninteractive
  Finish
}

# snap update
# you need to install the 'snap'
SnapUpdate() {
  Line
  echo -e "\n$bold UPDATING SNAP$reset$gray \n"
  sudo snap refresh
  Finish
}

# update the Arch User Repository
AurUpdate() {
  Line
  echo -e "\n$bold UPDATING AUR$reset$gray \n"
  yay -Syu --aur --noconfirm --cleanafter
  Finish
}

# ask if you want to restart the system
SystemRestart() {
  Line
  echo -e "\n$bold THE END$reset$gray \n"
  read -p " Do you want to restart the system (y/n)? " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    Finish
    reboot
  fi
  exit
}

# MENU ITEM
Update_all_the_system/menu() {
  sudo echo && Finish
  UpdateNews && UpdateAntivirus && ClearCache
  MirrorlistUpdate && KeysUpdate && OfficialRepositoryUpdate
  FlatpakUpdate && SnapUpdate && AurUpdate && SystemRestart
}

# MENU ITEM
Update_only_the_oficial_repository/menu() {
  sudo echo && Finish
  UpdateNews && ClearCache && MirrorlistUpdate
  KeysUpdate && OfficialRepositoryUpdate && SystemRestart
}

# MENU ITEM
Update_only_the_AUR/menu() {
  sudo echo && Finish
  UpdateNews && ClearCache && MirrorlistUpdate
  KeysUpdate && AurUpdate && SystemRestart
}

echo
while :; do                   # infinite menu loop
  echo -e "$gray " && FMenu   # create the network menu
  clear && Top
done
