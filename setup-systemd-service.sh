#!/bin/bash
#
# Setup a systemd service that can run the script xpad-trigger.sh.
#
# author: andreasl
set -e

if ! command -v systemd >/dev/null; then
    printf 'Error: systemd not found.\n'
    exit 1
fi
if ! command -v inotifywait >/dev/null; then
    printf 'Error: inotifywait not found.\n'
    exit 2
fi

sudo cp -v 'xpad-trigger.sh' '/usr/local/bin'
sudo cp -v 'xpad-trigger.service' '/lib/systemd/system'

printf 'systemd service xpad-trigger installed.\n'

printf 'Running\n   systemctl status xpad-trigger...\n'
sudo systemctl status xpad-trigger
