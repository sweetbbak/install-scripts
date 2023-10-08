#!/usr/bin/env bash

# You can change this values to fit your needs
width="1920"
height="1080"
blurstrength="16"

[[ $# -ne 1 ]] && echo "Usage: blurwal.sh <path_to_wallpaper>" && exit 1

wallpaper=$1 

if ! [[ -f $wallpaper ]] || ! identify $wallpaper > /dev/null 2> /dev/null;
then
    echo "$wallpaper is not a valid image"
    exit 2
fi;

wallpaperblur="${HOME}/.cache/wallpaperblur.png"
wallpapercomp="${HOME}/.cache/wallpapercomp.png"
wallpaperorig="${HOME}/.cache/wallpaperorig.png"

rm "$wallpaperblur" 2> /dev/null
rm "$wallpapercomp" 2> /dev/null
rm "$wallpaperorig" 2> /dev/null

# First we resize the image to fit our screen dimensions, saving it 
# to ~/.cache/wallpaperorig.png
# Note that this will only shrink images with at least one dimension larger than
# the respective screen dimension, it will not grow any low res images 
# (which I'm guessing is the desired behavior here)
convert "$wallpaper" \
    -resize $width\x$height\> \
    "$wallpaperorig"

# Then we resize the image to *overflow* our screen dimensions and blur it
# saving it to ~/.cache/wallpaperblur.png:
convert "$wallpaper" \
    -resize $width\x$height^ \
    -blur 0x$blurstrength \
    -gravity center \
    -crop $width\x$height+0+0 \
    "$wallpaperblur"

# Next we put the original image on top of the blurred one
# saving it to ~/.cache/wallpapercomp.png
convert -composite \
    -gravity center \
    "$wallpaperblur" "$wallpaperorig" "$wallpapercomp"

# And finally we set the wallpaper 
# This is done here with hsetroot, but you can use whatever program you want
# hsetroot -cover "$wallpapercomp"
nsxiv "$wallpapercomp"