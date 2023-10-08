#!/bin/bash
# backup TOTK save files

backup_location="$HOME/Documents/totk-saves"
target_path="$HOME/.local/share/yuzu/nand/user/save/0000000000000000/67199A4A0E6ED34755090EC0489B0D4F/0100F2C0115B6000/"

[ ! -d "$backup_location" ] && mkdir -p "$backup_location"
rsync --update --recursive --delete "$target_path" "$backup_location"
