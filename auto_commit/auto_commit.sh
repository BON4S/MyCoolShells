#!/bin/bash
# SCRIPT: auto-commit.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script monitors specific files and sends them
# to the repository when any of them are modified.
#
# USAGE:
# You can run the script without parameters, or you can
# specify the settigns file, just like in this example:
#  ./auto_commit.sh -s auto_commit_config➜mysettings.sh
# or just use the default config file: ./auto_commit.sh
#
# To use this script you DON'T edit this file,
# YOU MUST EDIT THE SETTINGS FILE (auto_commit_config➜default.sh)
#
# The first time you run the script (./auto_commit.sh) it will generate the md5,
# but it will not send the files to the repository. And the second time and the
# next times (when there are changes) the script will send the files to your repository.
#
# It is necessary to set up SSH keys for the script does not need password.
#
# Schedule the execution of the script for every 12 hours,
# editing cron with the command:  export VISUAL=nano; crontab -e
# and inserting a line like this in the file edition:
# 0 */12 * * * /home/your_username/scripts_folder/auto_commit/auto_commit.sh
#
#-------------------------------------------------------------------------------

# goes to script folder
script_folder=$(dirname "$0")
cd $script_folder

# default settings file
settings="auto_commit_config➜default.sh"

# checks for settings parameter
while [ -n "$1" ]; do
  case "$1" in
    -s | --settings)
      settings=$2
      shift
      ;;
    *) echo "Option $1 not recognized" ;;
  esac
  shift
done

# import settings
source $settings

# this checks the number of characters in the commit
characters() {
  if (( ${#1} > 50 )); then
    message="$(echo -e "💥ERROR! SCRIPT INTERRUPTED!💥\n\
    You are not very smart!\n\
    Your commit is longer than 50 characters.\n\
    COMMIT: $1\n\
    CHARACTERS: ${#1}.\n\
    ")"
    notify-send --urgency=critical "$message"
    zenity --error --width=500 --title="You are not very smart!" --text="$message"
    exit
  fi
}

# this checks if the files have been modified and sends them to the repository
check() {
  characters "$2"
  current=$(md5sum "$1" | cut -d' ' -f1)
  if [ "$current" != "$3" ] ; then
    if [ "$4" == "✖NULL" ]; then # commit in the same location as the file
      cd $(dirname "$1")
      git add $(basename "$1")
      git commit -m "$2"
      git push -u origin master
      cd $script_folder
    else  # copy and commit to a specific location
      cp $1 $4
      cd $4
      git add $(basename "$1")
      git commit -m "$2"
      git push -u origin master
      cd $script_folder
    fi
  fi
}
source md5.sh # it imports 'md5.sh' and calls the function 'check'

# this is to get and print the md5 of the monitored files
watch() {
  md5=$(md5sum "$1" | cut -d' ' -f1)
  if [ -z "$3" ]; then
    copy_folder=✖NULL
  else
    copy_folder=$3
  fi
  echo -e "check" "\"$1\"" "\"$2\"" "\"$md5\"" "\"$copy_folder\""
  # echo FILE: $1
  # echo COMMIT: $2
  # echo MD5: $md5
  # echo FOLDER: $copy_folder
}

# this generates the md5.sh file
md5() {
  files
}
md5 > md5.sh
