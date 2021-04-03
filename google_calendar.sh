#!/bin/bash
# SCRIPT: google_calendar.sh
# AUTHOR: imtherouser https://github.com/imtherouser
#
# ABOUT:
# This small script captures data from Google Calendar via
# gcalcli and organizes and displays it in a new format.
# This can be used, for example, to print the calendar
# on the desktop using 'Conky'.

gcalcli-run() {
  start_date=$(date +%Y-%m-%d)
  end_date=$(date +%Y-%m-%d -d "+ 14 day")   # stipulates the last 14 days for data capture
  gcalcli --nocolor agenda $start_date $end_date
}

IFS=$'\n'; appointment_data=($(gcalcli-run)) # capture the Google Calendar data

for n in "${!appointment_data[@]}"; do
  month=$(echo -ne ${appointment_data[n]} | cut -d" " -f2)
  week=$(echo -ne ${appointment_data[n]} | cut -d" " -f1)
  day=$(echo -ne ${appointment_data[n]} | cut -d" " -f3)
  title_and_time=$(echo -ne ${appointment_data[n]} | cut -c12- | xargs echo -n)

  if [ "Found..." = "$(echo $day)" ]; then
    echo "No appointments!"
  elif [ -z "$day" ]; then
    echo -e " - "$title_and_time
  else
    echo -e "\n "$day"/"$month", "$week
    echo -e " - "$title_and_time
  fi
done
