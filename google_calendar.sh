#!/bin/bash
# SCRIPT: google_calendar.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This little script captures data from my Google Calendar via gcalcli.
# I use it to print my appointments on desktop (using Conky).

gcalcli-run() {
  initialdate=$(date +%Y-%m-%d)
  enddate=$(date +%Y-%m-%d -d "+ 15 day")   # stipulates the last 15 days for data capture
  gcalcli --nocolor agenda $initialdate $enddate
}

IFS=$'\n'; events=($(gcalcli-run))                    # capture the Google Calendar data
for n in "${!events[@]}"; do
  day=$(echo -ne ${events[n]} | cut -c 9-10)          # separate the day from captured
  month=$(echo -ne ${events[n]} | cut -c 5-7)         # month
  week=$(echo -ne ${events[n]} | cut -c -3)           # week
  time=$(echo -ne ${events[n]} | cut -c 13-17)        # time
  if [ "s " = "$(echo $day)" ]; then                  # checks if there is something on the agenda
    echo "YEAH!  (^_^)"
    echo "No appointments!"
  elif [[ $time = *[!\ ]* ]]; then                    # check if there is a set time
    time=$(echo -ne " - $time")
    description=$(echo -ne ${events[n]} | cut -c28-)  # appointment title
    case $day in
      ''|*[!0-9]*) echo -e " on the same day$time\n "$description"\n " ;;
      *) echo -e " "$day"/"$month", "$week$time"\n "$description"\n " ;;
    esac
  else
    description=$(echo -ne ${events[n]} | cut -c20-)
    case $day in
      ''|*[!0-9]*) echo -e " on the same day\n "$description"\n " ;;
      *) echo -e " "$day"/"$month", "$week"\n "$description"\n " ;;
    esac
  fi
done
