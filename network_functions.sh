#!/bin/bash
# SCRIPT: network_functions.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: Network functions.

# show the internet connection status
connection() {
  wget -q --spider https://google.com
  if [ $? -eq 0 ]; then
    adapter=$(iwgetid | cut -d" " -f1)
    ssid=$(iwgetid | cut -d":" -f2 | sed -e 's/\"//g')
    echo -e $bold$green"CONNECTED "$reset$dim$green$ssid "("$adapter")"$reset$gray" "
  else
    echo -e $bold$lred"DISCONNECTED"$reset$gray" "
  fi
}

# run the wifi-menu choosing a network cards
wifi() {
  echo -e "\n WIFI-MENU"
  echo -e "\n Choose a interface"
  action() {
    sudo wifi-menu "${list[choice]}"
  }; lmenu2 "$(ls /sys/class/net)"
}

# connect to my favorite internet network
rede5ghz() {
  sudo netctl-auto switch-to wlp0s26u1u2-REDE5GHZ
}

# with that you can remove a wrong internet profile
remove_netctl_profile() {
  IFS=$'\n'; perfis=$(ls /etc/netctl/ | grep 'wlp')
  echo -e "\n PROFILES"
  action() {
    echo -e " PROFILE TO REMOVE:$yellow ${list[choice]}$gray "
    sudo rm "/etc/netctl/${list[choice]}"
    echo " DONE!"
    sleep 2
  }; lmenu2 "$perfis"
}

# enable or disable a network card
enable_or_disable_network_card() {
  echo -e "\n ENABLE/DISABLE A NETWORK CARD"
  echo -e "\n Choose a interface"
  action() {
    read -p " 'e' to enable or 'd' to disable: " choose
    case $choose in
      "e") sudo ifconfig "${list[choice]}" up && echo " OK!" && sleep 2 ;;
      "d") sudo ifconfig "${list[choice]}" down && echo " OK!" && sleep 2 ;;
      *) echo -e "\n$lred WRONG!$gray " && sleep 2 ;;
    esac
  }; lmenu2 "$(ls /sys/class/net)"
}

# it beeps when the internet connection comes back
beeps_when_the_internet_comes_back() {
  amixer -D pulse sset Master 100%  # set volume to 100%
  while :; do
    clear
    echo -e "\n\n$blue         CONNECTION CHECK \n$reset$gray "
    echo -en "         ping.. "
    wget -q --spider https://google.com
    if [ $? -eq 0 ]; then
      echo -e $bold$green"      CONNECTED!!"$reset$gray" \n"
      echo -e "         alarm.. \e]11;#2b2d35"
      mplayer -really-quiet /mnt/home2/m/sons-diversos/alarme-01.mp3
      echo -en "\n\n\n$reset$gray     waiting 10 seconds.."
      sleep 10
    else
      echo -e $bold$lred"  DISCONNECTED"$reset$gray" \n"
      echo -en "         waiting 5 seconds.."
      sleep 5
    fi
  done
}