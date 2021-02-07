#!/bin/bash
# SCRIPT: docker.sh
# AUTHOR: BON4S https://github.com/BON4S
# DESCRIPTION: Starts or stop Docker containers.

# For this script to work it is necessary to have 'default.sh' in the same folder.

clear
# --- default start ------------------------
cd $(dirname "$0")                              # goes to the script folder
source "default.sh"                             # import default.sh
# --- end of default start -----------------

IFS=$'\n'
containers_on=($(docker ps --format '{{.Names}} {{.ID}}'))
containers_all=($(docker ps -a --format '{{.Names}} {{.ID}}'))

containers_list() {
  for n in "${!containers_all[@]}"; do
    name=$(echo -ne ${containers_all[$n]} | cut -d" " -f1)
    number=$(($n+1))
    if printf '%s\n' "${containers_on[@]}" | cut -d" " -f1 | grep -q -P '^'$name'$'; then
      echo -e "$lgreen✔$reset $bold$number.$reset $name"
    else
      echo -e "$lred•$reset $bold$number.$reset $name"
    fi
  done
}

containers_list
echo
read -p 'Nº ' opt
option=$(($opt-1))

if [ ! -z "${containers_all[$option]}" ]; then
  name=$(echo -ne ${containers_all[$option]} | cut -d" " -f1)
  if printf '%s\n' "${containers_on[@]}" | cut -d" " -f1 | grep -q -P '^'$name'$'; then
    echo 'Stopping the container..'
    docker stop $name
  else
    echo 'Starting the container..'
    docker start $name
  fi
else
  echo -e $lred$bold"WRONG CHOICE!"
fi

sleep 2