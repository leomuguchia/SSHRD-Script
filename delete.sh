#!/bin/bash

# Function to display a simple progress bar
progress() {
  local duration=0.2  # Adjust the duration as needed
  local progress_char="#"
  local width=5

  printf "["
  for ((i = 0; i < width; i++)); do
    printf "$progress_char"
    sleep $duration
  done
  printf "....]\n"
}

# Log function with timestamp
log() {
  echo "$(date +"%H:%M:%S") - $1"
}

log "Removing saved activation files"
rm -rf ./files/com.apple.commcenter.device_specific_nobackup.plist
rm -rf ./files/data_ark.plist
rm -rf ./files/FairPlay
progress

log "Cleanup complete."

