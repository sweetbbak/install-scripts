#!/bin/bash
# simple script to extract files in their own damn folder
set -x

file="${1}"
filebname="$(basename "$file")"
filename="${filebname%.*}"
filename="${filename,,}"
filename="${filename/ /-}"

filedir="$(dirname "$file")"

ext() {
    if [ -f "$1" ] ; then
    	case $1 in
    		*.tar.bz2)	tar xjf "$1"	;;
    		*.tar.gz)	tar xzf "$1"	;;
    		*.bz2)		bunzip2 "$1"	;;
    		*.rar)		unrar x "$1"	;;
    		*.gz)		gunzip "$1"	;;
    		*.tar)		tar xf "$1"	;;
    		*.tbz2)		tar xjf "$1"	;;
    		*.tgz)		tar xzf "$1"	;;
    		*.zip)		unzip "$1"	;;
    		*.7z)		7z x "$1"		;;
    		*.tar.xz)	tar xf "$1"	;;
    		*.tar.zst)	unzstd "$1"	;;
    		*)		echo "'$1' cannot be extracted via ex()" ;;
    	esac
    else
    	echo "'$1' is not a valid file"
    fi
}

main() {
    # mkdir without extension
    dir="${filedir}/${filename}"
    extarget="${filedir}/${filename}/${filebname}"

    mkdir -p "${dir}"

    if [ ! -f "${dir}/${filebname}" ]; then
        mv "${file}" "${dir}"
    fi

    pushd "${dir}" || exit
    ext "${extarget}"
}

main
