#!/bin/env bash

command="$(rofi -dmenu -p "exec" -l 1)"
bash -c "$command"