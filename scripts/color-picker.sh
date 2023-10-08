#!/bin/bash

TRUE=1
FALSE=0

SELECTED_TAB=0
CURSOR_IN_HEAD=1
CURSOR_X=0
CURSOR_Y=0

SELECTED="\e[4m"
CURSOR="\e[7m"
RESET="\e[0m"

tab_titles=( "16 Color Mode" "256 Color Mode" )

function draw_tabs {
	local padding=2
	local margin=$(( $WIDTH - 13 - 14 - $padding ))
	margin=$(($margin / 2))
	printf "\e[${margin}C"
	for (( i = 0; i < ${#tab_titles[@]}; i++ )); do
		if [ $SELECTED_TAB -eq $i ]; then
			printf $SELECTED
		fi
		if [ $CURSOR_IN_HEAD -eq $TRUE ] && [ $CURSOR_X -eq $i ]; then
			printf $CURSOR
		fi
		printf "${tab_titles[$i]}$RESET"
		#printf "%-${padding}s"
		printf "\e[${padding}C"
	done
}

function max_cx {
	if [ $CURSOR_IN_HEAD -eq $TRUE ]; then
		expr ${#tab_titles[@]} - 1
	else
		printf 2
	fi
}

function arr_contains {
	idx=$1
	shift
	for v in $@; do
		if [ $v -eq $idx ]; then
			printf $TRUE
			return
		fi
	done
	printf $FALSE
}

function max {
	local max=$1
	for v in $@; do
		if [ $v -gt $max ]; then
			max=$v
		fi
	done
	printf "%d" $max
}

function min {
	local min=$1
	for v in $@; do
		if [ $v -lt $min ]; then
			min=$v
		fi
	done
	printf "%d" $min
}

function max_cy {
	if [ $CURSOR_X -eq 0 ]; then
		printf 5
	else
		if [ $SELECTED_TAB -eq 0 ]; then
			printf 15
		else
			printf 255
		fi
	fi
}

# $1:  horizontal  / vertical
# $2: right / left - up / down
function move_cursor {
	if [ $1 -eq $TRUE ]; then
		if [ $SELECTED_TAB -eq 1 ] && [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -gt 0 ]; then
			# if in a 256-color list, move an entry in there
			if [ $2 -eq $TRUE ]; then
				if [ $(($CURSOR_Y % 6)) -ne 3 ]; then
					let CURSOR_Y=$CURSOR_Y+1
				else # at the right margin of the list, switch to the next column
					DIRTY[$CURSOR_X]=$TRUE
					let CURSOR_X=$CURSOR_X+1
					let CURSOR_Y=$CURSOR_Y-5 # go to the left margin of the next col
					CURSOR_Y=$(max $CURSOR_Y 0)
				fi
			else # in a 256-color list, moving to the left
				if [ $((($CURSOR_Y - 5) % 6)) -ne 5 ]; then
					let CURSOR_Y=$CURSOR_Y-1
				else # at the left margin of the list, switch to the prev column
					DIRTY[$CURSOR_X]=$TRUE
					let CURSOR_X=$CURSOR_X-1
					[ $CURSOR_X -gt 0 ] && let CURSOR_Y=$CURSOR_Y+5
					CURSOR_Y=$(min $CURSOR_Y $(max_cy))
					# go to the right margin of the prev col
				fi
			fi
		else # either in tab 0 or in the head, this is easier:
			if [ $2 -eq $TRUE ] && [ $CURSOR_X -lt $(max_cx) ]; then
				DIRTY[$CURSOR_X]=$TRUE
				let CURSOR_X=$CURSOR_X+1
				[ $CURSOR_IN_HEAD -eq $TRUE ] && select_entry
			elif [ $2 -eq $FALSE ] && [ $CURSOR_X -gt 0 ]; then
				DIRTY[$CURSOR_X]=$TRUE
				let CURSOR_X=$CURSOR_X-1
				[ $CURSOR_IN_HEAD -eq $TRUE ] && select_entry
			fi
		fi
	else
		# up and down:
		if [ $2 -eq $TRUE ]; then
			if [ $CURSOR_Y -eq 0 ]; then
				CURSOR_IN_HEAD=$TRUE
				DIRTY[$CURSOR_X]=$TRUE
				CURSOR_X=$SELECTED_TAB
			elif [ $SELECTED_TAB -eq 1 ] && [ $CURSOR_X -gt 0 ] && [ $CURSOR_Y -lt 5 ]; then
				# also switch to title:
				CURSOR_IN_HEAD=$TRUE
				DIRTY[$CURSOR_X]=$TRUE
				CURSOR_X=$SELECTED_TAB
			else
				if [ $SELECTED_TAB -eq 0 ] || [ $CURSOR_X -eq 0 ]; then
					let CURSOR_Y=$CURSOR_Y-1
				else
					# in a 256-color-list:
					let CURSOR_Y=$CURSOR_Y-6
				fi
			fi
		else
			if [ $CURSOR_IN_HEAD -eq $TRUE ]; then
				CURSOR_IN_HEAD=$FALSE
				CURSOR_X=0
			elif [ $SELECTED_TAB -eq 0 ] || [  $CURSOR_X -eq 0 ]; then
				[ $CURSOR_Y -lt $(max_cy) ] && let CURSOR_Y=$CURSOR_Y+1
			else
				[ $CURSOR_Y -lt $(($(max_cy) - 5)) ] && let CURSOR_Y=$CURSOR_Y+6
			fi
		fi
	fi
}

function switch_mod {
	for i in "${!SELECTED_MODS[@]}"; do
		if [[ ${SELECTED_MODS[$i]} -eq "$1" ]]; then
			unset 'SELECTED_MODS[$i]'
			return
		fi
	done
	SELECTED_MODS+=("$1")
}

SELECTED_MODS=()
SELECTED_FG=5
SELECTED_BG=8
function select_entry {
	if [ $CURSOR_IN_HEAD -eq $TRUE ]; then
		SELECTED_TAB=$CURSOR_X
		clear
		DIRTY=($TRUE $TRUE $TRUE)
	else
		case $CURSOR_X in
			0) switch_mod $CURSOR_Y;;
			1) SELECTED_FG=$CURSOR_Y ;;
			2) SELECTED_BG=$CURSOR_Y ;;
		esac
		#clear
		#DIRTY=($TRUE $TRUE $TRUE)
	fi
}

# $1: whether to format mods
# $2: whether to format fg
# $3: whether to format bg
# $4: format or print
function format_selected {
	if [ $4 -eq $TRUE ]; then
		pfx="\\"
	else
		pfx="\\\\"
	fi

	if [ $1 -eq $TRUE ]; then
		for mod in ${SELECTED_MODS[@]}; do
			printf "${pfx}e[%sm" ${codes[$mod]}
		done
	fi

	if [ $2 -eq $TRUE ]; then
		if [ $SELECTED_TAB -eq 0 ]; then
			printf "${pfx}e[%d%dm" $(fgtoi $TRUE $SELECTED_FG)
		else
			printf "${pfx}e[38;5;%dm" $SELECTED_FG
		fi
	fi
	if [ $3 -eq $TRUE ]; then
		if [ $SELECTED_TAB -eq 0 ]; then
			printf "${pfx}e[%d%dm" $(fgtoi $FALSE $SELECTED_BG)
		else
			printf "${pfx}e[48;5;%dm" $SELECTED_BG
		fi
	fi
}

function menu {
	mytab=$(echo -e "\t")
	myenter=$(echo -e "\n")
	myescape=$(echo -e "\e")
	IFS=" "
	while true; do
		draw
		read -rsn1 line
		[ "$line" = "$myescape" ] && read -rsn2 line
		case "$line" in
			"$mytab")
				DIRTY[$CURSOR_X]=$TRUE
				let CURSOR_X=$CURSOR_X+1
				CURSOR_X=$(($CURSOR_X % ($(max_cx) + 1)))
				[ $CURSOR_IN_HEAD -eq $TRUE ] && select_entry
				;;
			"$myenter")
				select_entry ;;
			"q")
				close ;;
			"h" | "[D") move_cursor $TRUE $FALSE ;;
			"j" | "[B") move_cursor $FALSE $FALSE ;;
			"k" | "[A") move_cursor $FALSE $TRUE ;;
			"l" | "[C") move_cursor $TRUE $TRUE ;;
			"[Z")
				DIRTY[$CURSOR_X]=$TRUE
				let CURSOR_X=$CURSOR_X-1
				CURSOR_X=$(($CURSOR_X % ($(max_cx) + 1)))
				[ $CURSOR_IN_HEAD -eq $TRUE ] && select_entry
				;;
		esac
	done
}

# $1: pfx
# $2: i
function itofg {
	if [ $1 -lt 5 ]; then
		printf $(( $i * 2 ))
	else
		printf $(( $i * 2 + 1 ))
	fi
}

# $1: whether fg or bg
# $2: fg/bg value
function fgtoi {
	if [ $(($2 % 2)) -eq 0 ]; then
		if [ $1 -eq $TRUE ]; then
			printf "3 $(($2 / 2))"
		else
			printf "4 $(($2 / 2))"
		fi
	else
		if [ $1 -eq $TRUE ]; then
			printf "9 $((($2 - 1) / 2))"
		else
			printf "10 $((($2 - 1) / 2))"
		fi
	fi
}

# $1: pfx
# $2: i
function itoname {
	local names=( Black Red Green Yellow Blue Magenta Cyan Gray)
	if [ $1 -lt 5 ]; then
		if [ $2 -eq 7 ]; then
			#printf " %3d: %-${width}s" $1$2 "Light Gray"
			printf "Light Gray"
		else
			#printf " %3d: %-${width}s" $1$2 "${names[$2]}"
			printf "${names[$2]}"
		fi
	else
		if [ $2 -eq 7 ]; then
			#printf " %3d: %-${width}s" $1$2 "White"
			printf "White"
		elif [ $2 -eq 0 ]; then
			#printf " %3d: %-${width}s" $1$2 "Dark Gray"
			printf "Dark Gray"
		else
			#printf " %3d: %-${width}s" $1$2 "Light ${names[$2]}"
			printf "Light ${names[$2]}"
		fi
	fi
}

# $1: fg / bg
# $2: left start
# $3: selected entry (-1 for none)
function draw_16list {
	local width=14
	[ $1 -eq $TRUE ] && pfxs=( 3 9 ) || pfxs=( 4 10 )
	for (( i = 0; i < 8; i++ )); do
		for pfx in ${pfxs[@]}; do
			printf "\n\e[$2C"

			# invert fg on bright / dark bgs
			if [ $1 -eq $FALSE ]; then
				if [ $i -eq 0 ]; then
					printf "\e[97m"
				else
					printf "\e[30m"
				fi
			fi
			#if [ $1 -eq $FALSE ]; then
			#	format_selected $TRUE $TRUE $FALSE
			#else
			#	format_selected $TRUE $FALSE $TRUE
			#fi

			# draw cursor:
			tfg=$(itofg $pfx $i)
			if [ $3 -eq $tfg ]; then
				printf $CURSOR
			fi

			if [ $1 -eq $TRUE ]; then
				if [ $SELECTED_FG -eq $tfg ]; then
					printf "$SELECTED"
				fi
			else
				if [ $SELECTED_BG -eq $tfg ]; then
					printf "$SELECTED"
				fi
			fi

			# draw text:
			printf "\e[$pfx${i}m"
			printf " %3d: %-${width}s" $pfx$i "$(itoname $pfx $i)"
			printf "$RESET"
		done
	done
	printf "\e[16A"
}

#1: fg / bg
#2: left start
#3: selected entry
function draw_256list {
	printf $RESET
	if [ $1 -eq $TRUE ]; then
		pfx=38
	else
		pfx=48
	fi

	for ((i = -2; i <= 250; i = $i + 6)); do
		printf " \n\e[$2C"
		for ((j = 0; j < 6; j++)); do
			col=$(($i + $j))
			if [ $col -lt 0 ]; then
				printf "    "
				continue
			fi
			printf " "
			if [ $3 -eq $col ]; then
				printf "$CURSOR";
			fi
			if [ $1 -eq $TRUE ] && [ $col -eq $SELECTED_FG ]; then
				printf "$SELECTED"
			elif [ $1 -eq $FALSE ] && [ $col -eq $SELECTED_BG ]; then
				printf "$SELECTED"
			fi
			printf "\e[%d;5;%dm%03d$RESET" $pfx $col $col
		done
	done
	printf "\e[43A"
}

# $1: left start
# $2: selected
codes=( 1 2 3 4 5 7 8 )
mods=( Bold Dim Cursive Underlined Blink Invert Hidden )
function draw_modlist {
	local width=12
	for ((i = 0; i < 6; i++)); do
		printf "\n"
		if [ $2 -eq $i ]; then
			printf $CURSOR
		fi
		if [ $(arr_contains $i ${SELECTED_MODS[@]}) -eq $TRUE ]; then
			printf "x"
		else
			printf " "
		fi
		printf "%2d: ${mods[$i]} \e[%dmText" ${codes[$i]} ${codes[$i]}
		printf $RESET
		if [ $2 -eq $i ]; then
			printf $CURSOR
		fi
		printf "%-$(($width - ${#mods[$i]}))s"
		printf $RESET
	done
	printf "\e[12B"
}

function draw_preview {
	local padding=2
	local margin=$((($WIDTH - ${#PREVIEW} - $padding) / 2))

	printf "\n%-${margin}s"
	format_selected $TRUE $TRUE $TRUE $TRUE
	printf "\e[24m"
	printf "%-$((${#PREVIEW} + 2 * $padding))s"
	printf "$RESET"

	printf "\n%-$(($margin))s"

	format_selected $TRUE $TRUE $TRUE $TRUE
	printf "\e[24m%-${padding}s"

	format_selected $TRUE $TRUE $TRUE $TRUE
	printf "${PREVIEW[@]}"

	printf "\e[24m%-${padding}s"
	printf "$RESET"

	printf "\n%-${margin}s"
	format_selected $TRUE $TRUE $TRUE $TRUE
	printf "\e[24m%-$((${#PREVIEW} + 2 * $padding))s"
	printf "$RESET"
}

WIDTH=77 # width of the selection screen
DIRTY=($TRUE $TRUE $TRUE)
function draw {
	#if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq $3 ]; then
	#clear
	if [ $SELECTED_TAB -eq 0 ]; then
		printf "\e[22A"
		printf "\e[1A\n"
		draw_tabs
		printf "\n" # separator

		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 2 ]; then
			draw_16list $FALSE 51 $CURSOR_Y 
		else
			[ ${DIRTY[2]} -eq $TRUE ] && draw_16list $FALSE 51 -1
			DIRTY[2]=$FALSE
		fi
		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 1 ]; then
			draw_16list $TRUE 25 $CURSOR_Y 
		else
			[ ${DIRTY[1]} -eq $TRUE ] && draw_16list $TRUE 25 -1
			DIRTY[1]=$FALSE
		fi
		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 0 ]; then
			draw_modlist 1 $CURSOR_Y 
		else
			[ ${DIRTY[0]} -eq $TRUE ] && draw_modlist 1 -1
			[ ${DIRTY[0]} -eq $FALSE ] && printf "\e[18B"
			DIRTY[0]=$FALSE
		fi
	elif [ $SELECTED_TAB -eq 1 ]; then
		printf "\e[49A"
		printf "\e[1A\n"
		draw_tabs
		printf "\n" # separator

		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 2 ]; then
			draw_256list $FALSE 51 $CURSOR_Y
		else
			[ ${DIRTY[2]} -eq $TRUE ] && draw_256list $FALSE 51 -1
			DIRTY[2]=$FALSE
		fi
		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 1 ]; then
			draw_256list $TRUE 25 $CURSOR_Y 
		else
			[ ${DIRTY[1]} -eq $TRUE ] && draw_256list $TRUE 25 -1
			DIRTY[1]=$FALSE
		fi
		if [ $CURSOR_IN_HEAD -eq $FALSE ] && [ $CURSOR_X -eq 0 ]; then
			draw_modlist 1 $CURSOR_Y && printf "\e[27B"
		else
			[ ${DIRTY[0]} -eq $TRUE ] && draw_modlist 1 -1 && printf "\e[27B"
			[ ${DIRTY[0]} -eq $FALSE ] && printf "\e[45B"
			DIRTY[0]=$FALSE
		fi
		#printf "\e[30B"
	fi
	draw_preview
}

function squash-code {
	sed 's/m\\e\[/;/g' <<< $1 | tr -d '\n'
}

function close {
	echo "\e[?7h"
	IFS="$oldifs"
	tput cvvis
	tput rmcup
	printf "You selected"
	for i in "${!SELECTED_MODS[@]}"; do
		if [ $i -gt 0 ]; then
			printf ", %s" ${mods[${SELECTED_MODS[$i]}]}
		else
			printf " %s" ${mods[${SELECTED_MODS[$i]}]}
		fi
	done
	printf " text in "
	if [ $SELECTED_TAB -eq 0 ]; then
		pfxi=$(fgtoi $TRUE $SELECTED_FG)
		printf "%s" "$(itoname $pfxi)"
		printf " (%d%d)" $pfxi
	else
		printf "\e[38;5;%dm#%03d$RESET" $SELECTED_FG $SELECTED_FG
	fi

	printf " on "

	if [ $SELECTED_TAB -eq 0 ]; then
		pfxi=$(fgtoi $FALSE $SELECTED_BG)
		printf "%s" "$(itoname $pfxi)"
		printf " (%d%d)" $pfxi
	else
		printf "\e[48;5;%dm#%03d$RESET" $SELECTED_BG $SELECTED_BG
	fi

	printf ".\n"

	printf "The escape code for this combination is $SELECTED"
	squash-code $(format_selected $TRUE $TRUE $TRUE $FALSE)
	printf "$RESET .\n"
	exit
}

echo "Launched at $(date)" >> /tmp/picker.log

if [ command -v fortune &> /dev/null ]; then
	PREVIEW=$(fortune)
else
	PREVIEW="Lorem ipsum dolor sit amet"
fi

trap close SIGINT

tput smcup
tput civis
echo "\e[?7l"
oldifs="$IFS"
clear
menu
