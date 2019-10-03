#!/bin/bash
#
# Watch the files in $HOME/Barn/Notes/xpad-notes
# and if files change that have a matching script FILE-trigger.*,
# execute the according script in parallel.
#
# Note:
# I use a hardcoded, unconventional watch path.
# Usually, $xpad_dir should be the right path.
#
# author: andreasl

my_special_watch_path="${HOME}/Barn/Notes/xpad-notes"
xpad_dir="$HOME/.config/xpad"

inotifywait -e close_write,moved_to,create -m -r "$my_special_watch_path" 2>/dev/null |
while read -r directory events filename; do
    notename="${filename/content-/}"
    echo ">>> $(date)  $filename   $events   $notename"

    trigger_script="$(find "${xpad_dir}/trigger/" -iname "${notename}-trigger*" -print -quit)"
    if [ -x "$trigger_script" ]; then
        ./"$trigger_script" &
    fi
done
