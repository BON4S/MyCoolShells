#!/bin/bash
# SCRIPT: network.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: This is a menu that calls functions for my network.

clear
# --- default start ---
cd $(dirname "$0")                # goes to the script folder
source "header.sh"                # import header.sh
Top() {
  Title "NETWORK THINGS$lred!"
}; Top                            # show the title
# --- end of default start ---

source "network_functions.sh"     # import the network functions
Connection                        # show the internet connection

# MENU ITEM - close option
Exit/menu() {
  exit
}

# MENU ITEM - return option
Return_to_menu_-_fast.sh/menu() {
  if [ "$terminal" = "xfce4-terminal" ]; then
    Terminal "--geometry=60x25+450+220 --hide-menubar --hide-toolbar --hide-borders -e ./fast.sh"
  else
    Terminal "-e ./fast.sh"
  fi; exit
}

# to understand the functions below look at the network_functions.sh

# MENU ITEM - run the wifi-menu choosing a network cards
Run_the_wifi-menu/menu() {
  RunTheWifiMenu
}

# MENU ITEM - connect to my favorite internet network
Connect_to_wlp0s26u1u2-REDE5GHZ/menu() {
  ConnectToREDE5GHZ
}

# MENU ITEM - remove wrong netctl internet profiles
Remove_a_netctl_profile/menu() {
  RemoveNetctlProfile
}

# MENU ITEM - open netctl profiles folder
Open_netctl_profile_folder/menu() {
  setsid thunar /etc/netctl/ &
}

# MENU ITEM - enable or disable a network card
Enable_or_disable_a_network_card/menu() {
  EnableDisableNetworkCard
}

while :; do                      # infinite menu loop
  echo -e "$gray " && FMenu      # create the network menu
  clear && Top && Connection
done
