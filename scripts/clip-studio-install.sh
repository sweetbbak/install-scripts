#!/bin/bash
# install CSP using wine

WINEPREFIX=~/games/clip-studio
setup=https://vd.clipstudio.net/clipcontent/paint/app/11110/CSP_11110w_setup.exe

[ ! -f CSP_11110w_setup.exe ] && wget "${setup}"
winecfg
wine "${setup}"