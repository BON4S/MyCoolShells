#!/bin/bash
# SCRIPT: shortcuts.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: Script to open shortcuts dialog when click in some taskbar icon.
# USAGE: xfce4-terminal --minimize -e "shortcuts.sh editors"
# DEPENDENCIES: yad
#
# THAT WAS DONE QUICKLY! IT'S UGLY! :))
#
# TODO: FIND AN ALTERNATIVE TO YAD - remove the quick display of the terminal on the screen.
# TODO: Rewrite this code.
shortcut() {
  choices=$(yad --height=300 --width=300 --posx=-530 --posy=420 --list --undecorated --title=" " --text="Select:" --radiolist --column=" " --column="$1" $2);
  [ -z "$choices" ] && exit || the_choice=$(echo "$choices" | cut -d'|' -f2)
  if [ "leafpad_(sudo)" = "$the_choice" ]; then
    xfsudo nohup leafpad &
  elif [ "vscode" = "$the_choice" ]; then
    setsid code &
  elif [ "firefox-developer-edition_(firejail)" = "$the_choice" ]; then
    setsid firejail firefox-developer-edition &
  elif [ "download" = "$the_choice" ]; then
    xfce4-terminal --geometry=80x15+550+430 --hide-menubar --hide-toolbar --hide-borders -e "/mnt/home2/dev/sh/ignore/download.sh"
  else
    setsid $the_choice &
  fi
  sleep 8   # necessary time to open some programs
  exit
}
case $1 in
  "editors") shortcut "EDITORS" "FALSE leafpad_(sudo) FALSE leafpad TRUE vscode" ;;
  "browsers/news") shortcut "BROWSERS/NEWS" "FALSE liferea FALSE download FALSE chromium FALSE firefox-developer-edition TRUE firefox-developer-edition_(firejail)" ;;
  *) exit;;
esac