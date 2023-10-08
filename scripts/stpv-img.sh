#!/bin/sh

# Copyright (C) 2019-present naheel-azawy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/stpv"
CFG_FILE="$CFG_DIR/config.sh"

TOGGLE="$HOME/.config/stpv/noimgpv"
CMD=; ID=; FIFO=; FPID=

exists() {
    command -v "$1" >/dev/null
}

iswayland() {
    [ -n "$WAYLAND_DISPLAY" ] ||
        [ "$XDG_SESSION_TYPE" = 'wayland' ]
}

iskitty() {
    [ -n "$KITTY_PID" ]
}

toggle() {
    if [ -f "$TOGGLE" ]; then
        rm -f "$TOGGLE"
    else
        d=$(dirname "$TOGGLE")
        mkdir -p "$d"
        touch "$TOGGLE"
    fi
}

isenabled() {
    [ "$PV_IMAGE_ENABLED" = 1 ] || [ ! -f "$TOGGLE" ]
}

isalive() {
    [ "$PV_TYPE" != img ] && return 0
    iskitty || [ -e "$FIFO" ]
}

listen() {
    [ "$PV_TYPE" != img ] && return 0
    iskitty && return 0

    # cleanup any dead listeners if any
    find /tmp/ -maxdepth 1 -name 'stpvimgfifo*-pid' | while read -r f; do
        pid=$(cat "$f")
        ppid=$(ps -h -p "$pid" -o ppid | xargs)
        if [ "$ppid" = 1 ]; then
            kill "$pid"
        fi
    done

    # if already listening, ignore
    [ -e "$FIFO" ] && return 0

    mkfifo "$FIFO"
    echo $$ > "$FPID"

    # echo "FIFO='$FIFO'"
    # echo "PID=$$"

    trap end EXIT
    tail -f "$FIFO" | ueberzug layer
}

fifo_open() {
    # https://unix.stackexchange.com/a/522940/183147
    dd oflag=nonblock conv=notrunc,nocreat count=0 of="$1" \
       >/dev/null 2>/dev/null
}

add() {
    F="$1"; X="$2"; Y="$3"; W="$4"; H="$5"
    if [ ! "$X" ] || [ ! "$Y" ] || [ ! "$W" ] || [ ! "$H" ]; then
        X=0; Y=0
        W=$(tput cols)
        H=$(tput lines)
    else
        # sometimes to goes a bit beyond the line below
        H=$((H - 1))
    fi

    if [ "$PV_TYPE" = text ]; then
        chafa                \
            --size "$W"x"$H" \
            "$F" 2>/dev/null

    elif [ "$PV_TYPE" = sixel ]; then
        chafa                \
            -f sixel         \
            --size "$W"x"$H" \
            "$F" 2>/dev/null | sed 's/#/\n#/g'

    elif iskitty; then
        kitty +kitten icat --transfer-mode file --align left \
              --place "${W}x${H}@${X}x${Y}" "$F" >/dev/tty

    else
        [ ! -e "$FIFO" ] && return 1
        fifo_open "$FIFO" && {
            path="$(printf '%s' "$F" | sed 's/\\/\\\\/g;s/"/\\"/g')"
            printf '{ "action": "add", "identifier": "preview", "x": %d, "y": %d, "width": %d, "height": %d, "scaler": "contain", "scaling_position_x": 0.5, "scaling_position_y": 0.5, "path": "%s"}\n' "$X" "$Y" "$W" "$H" "$path" > "$FIFO"
        }
    fi
}

clear() {
    [ "$PV_TYPE" != img ] && return 0

    iskitty && {
        kitty +kitten icat --clear --transfer-mode file
        return
    }

    [ ! -e "$FIFO" ] && return 1
    fifo_open "$FIFO" &&
        printf '{"action": "remove", "identifier": "preview"}\n' > "$FIFO"
}

end() {
    [ "$PV_TYPE" != img ] && return 0
    clear
    iskitty && return 0
    [ -f "$FPID" ] &&
        PID=$(cat "$FPID") &&
        rm -f "$FPID" &&
        pkill -TERM -P "$PID"
    rm -f "$FIFO"
}

usage() {
    BIN=$(basename "$0")
    echo "usage: $BIN [--listen id] [--add id picture [x y w h]] [--clear id] [--end id] [--alive id] [--toggle] [--enabled]"
    echo
    echo "Example usage:"
    echo "$ stpvimg --listen 0 &"
    echo "$ stpvimg --add 0 $HOME/1.png"
    echo "$ stpvimg --add 0 $HOME/2.png 0 10 20 20"
    echo "$ stpvimg --clear 0"
    echo "$ stpvimg --end 0"
    return 1
}

load_config() {
    [ -f "$CFG_FILE" ] && {
        s=$(sed -rn 's/(PV_.+)=(.+)/\1=\2/p' "$CFG_FILE")
        eval "$s"
    }
}

main() {
    load_config

    [ "$PV_IMAGE_ENABLED" = 0 ] || [ -f "$TOGGLE" ] &&
        return 1

    # if no display server
    [ -n "$DISPLAY" ] || PV_TYPE=text

    if [ "$PV_TYPE" = img ] && (iswayland || ! exists ueberzug) && ! iskitty; then
        # if it's sixel, it will be left alone
        PV_TYPE=text
    fi

    if [ "$PV_TYPE" != img ] && ! exists chafa; then
        return 1
    fi

    CMD="$1"
    ID="$2"

    [ -n "$1" ] && shift
    [ -n "$1" ] && shift

    # the fifo
    FIFO="/tmp/stpvimgfifo$ID"

    # pid of this listener
    FPID="$FIFO-pid"

    case "$CMD" in
        --listen)  listen "$@" ;;
        --add)     add    "$@" ;;
        --clear)   clear       ;;
        --end)     end         ;;
        --alive)   isalive     ;;
        --toggle)  toggle      ;;
        --enabled) isenabled   ;;
        *)         usage       ;;
    esac
}

main "$@"