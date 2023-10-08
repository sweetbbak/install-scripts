#!/bin/bash
title="$*"
ext=".MOBI|.CBZ|.CBR|.CBC|.CHM|.EPUB|.FB2|.LIT|.LRF|.ODT|.PDF|.PRC|.PDB|.PML|.RB|.RTF|.TCR"
intitle="index of"
inurl="jsp|pl|php|html|aspx|htm|cf|shtml"
inurl2="listen77|mp3raid|mp3toss|mp3drug|index_of|wallywashis"

search="+(${ext}) '${title}' intitle:'${intitle}' -inurl:(${inurl}) -inurl:(${inurl2})"
google="https://www.google.com/search?q="

firefox --new-tab "${google}${search}"
