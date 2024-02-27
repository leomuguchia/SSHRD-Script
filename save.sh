log() {
  echo "$(date +"%H:%M:%S") - $1"
}

run_ssh_command() {
  sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p2222 "$@"
}

copy_files() {
  sshpass -p 'alpine' scp -rP 2222 -o StrictHostKeyChecking=no root@localhost:"$1" "$2"
}

log "Mounting"
if run_ssh_command 'mount_filesystems'; then
  log "Mounted!"

  # Proceed to the next steps only if mounting was successful

  if copy_files "/mnt2/containers/Data/System/*/Library/activation_records/activation_record.plist" ./files/ 2>&1; then
    log "Activation record copied successfully"

    # Proceed to the next steps only if copying activation record was successful

    if copy_files "/mnt2/containers/Data/System/*/Library/internal/data_ark.plist" ./files/ 2>&1; then
      log "Data ARK copied successfully"

      # Proceed to the next steps only if copying data ARK was successful

      if copy_files "/mnt2/mobile/Library/FairPlay/" ./files/ 2>&1; then
        log "FairPlay folder copied successfully"

        # Proceed to the next steps only if copying FairPlay folder was successful

        if copy_files "/mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist/" ./files/ 2>&1; then
          log "Commcenter plist copied successfully"

          # Proceed to the next steps only if copying Commcenter plist was successful

          if run_ssh_command '/sbin/reboot' 2>&1; then
            log "Reboot successful"
            log "Activation files saved!"
          else
            log "Error: Failed to reboot"
          fi

        else
          log "Error: Failed to copy com.apple.commcenter.device_specific_nobackup.plist"
        fi

      else
        log "Error: Failed to copy FairPlay folder"
      fi

    else
      log "Error: Failed to copy data_ark.plist"
    fi

  else
    log "Error: Failed to copy activation_record.plist"
  fi

else
  log "Error: Failed to mount filesystems"
fi

# Kill iproxy when done
kill %1 > /dev/null 2>&1