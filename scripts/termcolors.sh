#!/bin/sh

help_text () {
        while IFS= read line; do
	    printf "%s\n" "$line"
	done <<-EOF
	Usage:
	    ${0##*/} [-t <term_name> | -f <format> | -o <your_config_path>] [<wallpaper_path>]
	    ${0##*/} -h
	
	Options:
	    -h show helptext
	    -t (lxterminal|st|kitty|xresources|nvim|shell)
	    -f write custom format (e.g. "color%s %s")
	    -o config file path
	
	custom format:
	    if ur terminal/application is not in the above list, you can write ur own custom format to generate color pallete
	    for e.g.: -f "color%s %s"
	    \		    	|  └─> color hex
	    \		    	└─> pallete number
	nvim & shell:
	    these ones are to be used with pywal.nvim plugin in neovim
	EOF
	exit 0
}

a="%s"
while getopts 'hf:t:o:' OPT; do
    case $OPT in
	t) term=$OPTARG;;
	f) a=$OPTARG;;
	o) file=$OPTARG;;
	*|h) help_text ;;
    esac
done
shift $((OPTIND - 1))

#main
[ -z "$*" ] && printf "please provide wallpaper path!!\n" && help_text || x=$(convert $* -scale 25% -colors 15 -unique-colors txt: | sed -nE 's/.* #([^ ]*).*/#\1/p' | sed '1,6d' | cut -c1-7)
if [ -n "$term" ];then
    case $term in
        lx*) 
		a="palette_color_%s=%s"
		[ -z "$file" ] && file=$HOME/.config/lxterminal/lxterminal.conf
		sed -i '/^palette_/d' $file;;
        kit*)
		a="color%s %s"
		[ -z "$file" ] && file=$HOME/.config/kitty/kitty.conf
		sed -i '/^color/d' $file;;
        Xre*|xre*) 
		a="*color%s:\t%s"
		[ -z "$file" ] && file=$HOME/.Xresources
		sed -i '/^\*color/d' $file;;
        st) 	a='[%s] = "%s",' ;;
	nv*)
		a='let color%s\t=\t"%s"'
		[ -z "$file" ] && file=$HOME/.cache/wal/colors-wal.vim
		sed -i '/^let color/d' $file;;
	sh*)
		a="color%s='%s'"
		[ -z "$file" ] && file=$HOME/.cache/wal/colors.sh
		sed -i '/^color/d' $file;;
	*) a="%s";;
    esac
fi
printf "default location : %s\n" "$file"
printf "$a\n" "0" "#121212" | grep '#' | tee -a $file
printf "$a\n" "8" "#838383" | grep '#' | tee -a $file
for i in $(seq 1 7);do
	printf "$a\n" "$i" "$(printf "$x" | sed -n "${i}p")" | grep '#' | tee -a $file
	printf "$a\n" "$((i+8))" "$(printf "$x" | sed -n "${i}p")" | grep '#' | tee -a $file
done
printf "Copy these color codes to ur terminal config if ur terminal is not in given presets, otherwise it already copied to default location make sure backup config before.. i m not responsible for any problem that mayhaps arise\n"

