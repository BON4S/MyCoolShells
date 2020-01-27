#!/bin/bash
# SCRIPT: fast.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script is used as a shortcut on the taskbar.
# It's a choice menu designed to make my life easier on some tasks
# and to put my other scripts in the same place, for quick access.

clear
# --- default start ---
cd $(dirname "$0")          # goes to the script folder
source "header.sh"          # import header.sh
Top() {
  Title "FAST MENU$lred!"
}; Top                      # show the title
# --- end of default start ---

#  MENU ITEM - close all
Exit_fast.sh/menu() {
  exit
}

# MENU ITEM - network things (see network.sh and network_functions.sh)
Network_and_connections/menu() {
  if [ "$terminal" = "xfce4-terminal" ]; then
    Terminal "--geometry=90x25+450+220 --hide-menubar --hide-toolbar --hide-borders -e ./network.sh"
  else
    Terminal "-e ./network.sh"
  fi; exit
}

# MENU ITEM - the best way to update Arch (see update_arch.sh)
Update_Arch_Linux/menu() {
  if [ "$terminal" = "xfce4-terminal" ]; then
    Terminal "--geometry=130x25+160+220 --hide-menubar --hide-toolbar --hide-borders -e ./update_arch.sh"
  else
    Terminal "-e ./update_arch.sh"
  fi; exit
}

# MENU ITEM - create and update my rss feed page (see news_page.sh)
Update_the_News_Page/menu() {
  ./news_page.sh --dark -d /mnt/home2/downloads_sda2
  exit
}

# MENU ITEM - hide or show my secret plans to rule the world
Safe_partition/menu() {
  echo
  read -p "'m' to mount 'u' to unmount: " opt
  case $opt in
    "m") echo -e "\nMOUNTING SAFE PARTITION" ;
      sudo cryptsetup luksOpen /dev/sda5 safe ;
      sudo mount /dev/mapper/safe /mnt/safe ;
      thunar /mnt/safe ;
      exit ;;
    "u") echo -e "\nUNMOUNTING SAFE PARTITION" ;
      sudo umount /mnt/safe ;
      sudo cryptsetup luksClose safe ;
      exit ;;
    *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
  esac
}

# MENU ITEM - show or hide my Google Drive using rclone
Virtual_drives/menu() {
  echo -e "\n MOUNT OR UNMOUNT A VIRTUAL DRIVE"
  read -p " 'm' to mount 'u' to unmount: " opt
  case $opt in
    "m") echo -e "\n MOUNTING.. CHOOSE ONE\n
      1. gdrive1 /
      2. gdrive1 /temp
      "
      read -p " Nº " opt
      case $opt in
        "1") rclone mount gdrive1: /mnt/home2/gdrive1 --daemon ;;
        "2") rclone mount gdrive1:temp /mnt/home2/gdrive1 --daemon ;;
        *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
      esac
      exit ;;
    "u") echo -e "\n UNMOUNTING.. CHOOSE ONE \n
      1. gdrive1
    "
    read -p " Nº " opt
    case $opt in
      "1") fusermount -u /mnt/home2/gdrive1 ;;
      *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
    esac
      exit ;;
    *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
  esac
}

# MENU ITEM - virtualizations
Emulate_something/menu() {
  echo -e "\n 1. Windows 10\n"
  read -p " Nº: " opt
  case $opt in
    "1") nohup VBoxManage startvm "3554780d-ed53-477f-8d0e-b03292951a3e" & ;;
    *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
  esac
  exit
}

# MENU ITEM - edit this file with the best editor in the world: nano
Edit_this_menu/menu() {
  echo
  read -p " 'v' VSCode, 'n' Nano: " opt
  case $opt in
    "v") code fast.sh && exit ;;
    "n") nano fast.sh && exit ;;
    *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
  esac
}

while :; do             # infinite menu loop
  echo -e "\n$gray "
  FMenu                 # create the network menu
  clear && Top
done
