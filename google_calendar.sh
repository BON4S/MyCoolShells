#!/bin/bash
# SCRIPT: google_calendar.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This little script captures data from my Google Calendar via gcalcli.
# I use it to print my appointments on desktop (using Conky).

RunGcalcli() {
  initialdate=$(date +%Y-%m-%d)
  enddate=$(date +%Y-%m-%d -d "+ 15 day")   # stipulates the last 15 days for data capture
  gcalcli --nocolor agenda $initialdate $enddate
}

IFS=$'\n'; events=($(RunGcalcli))                     # capture the Google Calendar data
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
    echo -e " "$day"/"$month", "$week$time
    echo -e " "$description"\n "
  else
    description=$(echo -ne ${events[n]} | cut -c20-)  # appointment title
    echo -e " "$day"/"$month", "$week
    echo -e " "$description"\n "
  fi
done
