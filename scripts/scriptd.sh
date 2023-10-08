#!/bin/bash

# sweetbbak - Poetic License
# finds all executable files in a dir and lets you run one
# just drop it in any directory where there are execetable files

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
files="$(fd . "$SCRIPT_DIR" --type executable)"
filenanes=()

IFS=$'\n'

for e in ${files[@]}; do
    filenames=("${filenames[@]}" ${e##*/}) 
done

choice=$(printf "%s\n" "${filenames[@]}" | rofi -dmenu) 
choice_path=$(printf "%s\n" "${files[@]}" | grep "$choice")
[ "$choice_path" ] && $choice_path

# script=$(fd . "$SCRIPT_DIR" --type executable -X printf '%s\n' {} | rofi -keep-right -i -dmenu -p "scripts ->")
# [ "$script" ] && "${script}"