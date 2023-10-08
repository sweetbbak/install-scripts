#!/bin/sh

cleanup() {
  if [ -f /tmp/screenshot.png ]; then 
    rm /tmp/screenshot.png 
  fi
}

screenshot_name() {
  name="$(printf "" | rofi -dmenu -l 0 -i -p "Enter a name for your screenshot:" -config ~/.config/rofi/styles/prompt.rasi)"
  [ -z "$name" ] && notify-send "Screenshot" "No name given" -i /tmp/screenshot.png && exit
  # check if a file with the same name already exists
  if [ -f "$HOME/Pictures/screenshots/$name.png" ]; then
    notify-send "Name already taken" "Please choose another name" -i /tmp/screenshot.png
    screenshot_name
  fi
}

trap cleanup EXIT INT TERM
case "$1" in
  fullscreen) 
    grimblast copysave output /tmp/screenshot.png
    ;;
  selectarea) 
    grimblast copysave area /tmp/screenshot.png
    ;;
  quickedit) 
    grim -g "$(slurp)" - | swappy -f - -o - > /tmp/screenshot.png
    wl-copy < /tmp/screenshot.png
    ;;
  save)
    grimblast save area /tmp/screenshot.png
    [ ! -f /tmp/screenshot.png ] && exit 1
    screenshot_name
    mv /tmp/screenshot.png "$HOME/Pictures/screenshots/$name.png"
    notify-send "Screenshot" "Saved to $HOME/Pictures/screenshots/$name.png" -i "$HOME/Pictures/screenshots/$name.png"
    exit
    ;;
    *) notify-send "Screenshot" "There was an error" ;;
esac

notify-send "Screenshot" "Copied to clipboard" -i /tmp/screenshot.png
