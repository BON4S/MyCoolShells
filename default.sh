#!/bin/bash
# SCRIPT: default.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: Basic code to use in all shell scripts.
# USAGE: source "default.sh"

# set terminal initial background color
printf %b "\e]11;#2b2d35\a"

# text colors (foreground)
black="\e[30m"  &&  white="\e[97m"
red="\e[31m"    &&  lred="\e[91m"
green="\e[32m"  &&  lgreen="\e[92m"
yellow="\e[33m" &&  lyellow="\e[93m"
blue="\e[34m"   &&  lblue="\e[94m"
pink="\e[35m"   &&  lpink="\e[95m"    # magenta
cyan="\e[36m"   &&  lcyan="\e[96m"
gray="\e[37m"   &&  dgray="\e[90m"    # gray and dark gray
reset_fg="\e[39m"                     # default text color

# text stylization
bold="\e[1m"
dim="\e[2m"
italic="\e[3m"
underline="\e[4m"
blink="\e[5m"
blink2="\e[6m"
reverse="\e[7m"
hidden="\e[8m"

# background colors
bg_black="\e[40m"  &&  bg_white="\e[107m"
bg_red="\e[41m"    &&  bg_lred="\e[101m"
bg_green="\e[42m"  &&  bg_lgreen="\e[102m"
bg_yellow="\e[43m" &&  bg_lyellow="\e[103m"
bg_blue="\e[44m"   &&  bg_lblue="\e[104m"
bg_pink="\e[45m"   &&  bg_lpink="\e[105m"   # magenta
bg_cyan="\e[46m"   &&  bg_lcyan="\e[106m"
bg_gray="\e[47m"   &&  bg_dgray="\e[100m"   # gray and dark gray
reset_bg="\e[49m"                           # default bg color

# reset bg and fg
reset="\e[0m"

# function to create titles
# usage example:  title "TITLE NAME"
title() {
  file_name="${0##*/}"
  echo -ne $bold$gray" $1 "$dim$gray$reverse" ${file_name^^} "$reset$gray" "
}

# FUNCTION MENU
# easily create menus from functions      <-- really cool :o)
# usage example:
#   menu_item_1/menu() {                  <-- "/menu" is required
#     command
#   }
#   fmenu
fmenu() {
  place="$1"
  if [ -z "$1" ]; then                              # check if any parameters have been passed
    place="$0"
    place="${place##*/}"                            # set the script itself as functions local
  fi
  menu=($(grep '/menu()' $place | cut -d'/' -f1))   # take the name of each function and put it in an array
  for n in "${!menu[@]}"; do
    num="($n+1)"
    echo -e " "$((num))." ${menu[n]//_/ }"          # replace underline with space and print the menu
  done
  error() {
    echo -e "$lred MENU NUMBER!$gray " && sleep 2
  }
  echo
  read -p ' Nº ' opt
  o="($opt-1)"
  if [ -z "${menu[o]}" ]; then      # check if the typed is a nonexistent number
    error
  else
    case $opt in
      ''|*[!0-9]*) error ;;         # check if the typed is a number
      0) error ;;                   # check if the typed is zero
      *) "${menu[o]}/menu" ;;       # execute the function chosen by the user
    esac
  fi
}

# FUNCTION MENU 2
# the same function menu, but with keyboard support
# up key: previous item
# down: next item
# space or right: choose the option
# q or left: quit
fmenu2() {
  place="$1"
  if [ -z "$1" ]; then                              # check if any parameters have been passed
    place="$0"
    place="${place##*/}"                            # set the script itself as functions local
  fi
  menu=($(grep '/menu()' $place | cut -d'/' -f1))   # take the name of each function and put it in an array
  cur=0
  draw_menu() {
    for i in "${menu[@]}"; do
      if [[ ${menu[$cur]} == $i ]]; then
        tput setaf 2; echo " ➜ ${i//_/ }"; tput sgr0
      else
        echo "   ${i//_/ }";
      fi
    done
  }
  draw_menu
  while read -sN1 key; do                                                       # 1 char (not delimiter), silent
    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}                                                        # catch multi-char
    case "$key" in
      q|a|''|$'\e'|$'\e[D'|$'\e0D') exit;;                                      # left: quit
      d|e|' '|$'^['|''|$'\e[C'|$'\e0C') break;;                                 # right, space: execute
      w|$'\e[A'|$'\e0A') ((cur > 0)) && ((cur--));;                             # up: previous item
      s|$'\e[B'|$'\e0B') ((cur < ${#menu[@]}-1)) && ((cur++));;                 # down: next item
    esac
    for i in "${menu[@]}"; do tput cuu1; done && tput ed                        # redraw menu
    draw_menu
  done
  echo -e "\n$lblue ❰ ${menu[$cur]//_/ } ❱$gray \n"
  "${menu[$cur]}/menu"
}

# LIST MENU
# easily create menus from a list
# usage example:
#   action() {                          <-- function that runs menu actions
#     echo "${list[choice]}";           <-- "${list[choice]}" return user choice
#   }; lmenu "$(ls /sys/class/net)"     <-- example list which will generate the menu
lmenu() {
  list=($1)
  for n in "${!list[@]}"; do
    num="($n+1)"
    echo -e " "$((num))." ${list[n]}"   # print the menu
  done
  error() {
    echo -e "$lred MENU NUMBER!$gray"
    sleep 2
  }
  echo
  read -p ' Nº ' opt                    # read the user choice
  choice="($opt-1)"
  if [ -z "${list[choice]}" ]; then     # check if the typed is a nonexistent number
    error
  else
    case $opt in
      ''|*[!0-9]*) error ;;             # check if the typed is a number
      0) error ;;                       # check if the typed is zero
      *) action ;;                      # execute the user function
    esac
  fi
}

# LIST MENU 2
# the same list menu, but with keyboard support
lmenu2() {
  list=($1)
  choice=0
  draw_menu() {
    for i in "${list[@]}"; do
      if [[ ${list[$choice]} == $i ]]; then
        tput setaf 2; echo " ➜ $i"; tput sgr0
      else
        echo "   $i";
      fi
    done
  }
  draw_menu
  while read -sN1 key; do                                                       # 1 char (not delimiter), silent
    read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
    key+=${k1}${k2}${k3}                                                        # catch multi-char
    case "$key" in
      q|a|''|$'\e'|$'\e[D'|$'\e0D') exit;;                                      # left: quit
      d|e|' '|$'^['|''|$'\e[C'|$'\e0C') break;;                                 # right, space: execute
      w|$'\e[A'|$'\e0A') ((choice > 0)) && ((choice--));;                       # up: previous item
      s|$'\e[B'|$'\e0B') ((choice < ${#list[@]}-1)) && ((choice++));;           # down: next item
    esac
    for i in "${list[@]}"; do tput cuu1; done && tput ed                        # redraw menu
    draw_menu
  done
  action
}

# colored line
line() {          # lolcat -> the best linux program after 'cowsay'
  echo "================================================" | lolcat
}

# looks for a terminal installed on the user's computer
# and runs it in parallel (setid) with parameters
# usage example: terminal "-e script.sh"
# can also print the terminal name with: terminal "name"
#                                    or: echo $the_terminal
terminal() {
  terms=(xfce4-terminal gnome-terminal konsole xterm)   # terminal list
  for t in ${terms[*]}; do
    if [ $(command -v $t) ]; then     # search for a terminal
      the_term=$t                     #
      break                           # and stops at the first one it finds (follows the list order)
    fi
  done
  if [ "$*" = "name" ]; then          # if the parameter is "name"
    echo $t                           # print the terminal name
  else                                # if not
    setsid $the_term $*               # execute the terminal with the parameter
  fi
}
the_terminal=$(terminal "name")       # put the terminal name into a variable
