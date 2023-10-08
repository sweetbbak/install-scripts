#!/bin/bash

# notify-send "TTS started $$"
text="$(wl-paste)"
kitty -e bash -c "/home/sweet/.local/bin/edge-tts -t \"${text}\" | play -t mp3 -"
# tmpfile="$(mktemp XXXXXX.mp3)"

# # delete file on exit
# trap '[ -f $tmpfile ] && rm $tmpfile' INT EXIT

# [ -n "$text" ] && {
#     # gtts-cli "${text}" | play -t mp3 -
#     edge-tts -t "${text}" --write-media "$tmpfile" &> /dev/null 

#     # kitty --class=catnip33 --hold -e mpv --loop-file=no --keep-open=no --loop-playlist=no "$tmpfile"
#     # sh -c play -t mp3 "$tmpfile"
# }
# echo "$tmpfile" &> /dev/stdout
# mpv --profile=pseudo-gui --loop-file=no --keep-open=no --loop-playlist=no "${tmpfile}"
