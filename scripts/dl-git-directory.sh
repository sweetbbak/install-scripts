#!/bin/bash
# simple script to download a single folder from
# a github repo // sweetbbak
# dependency: wget
# optional dependency: gum

base_url="https://download-directory.github.io"

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
    echo -en "${0##*/} <url-to-git-folder>"
fi

if [ -n "${1}" ]; then
    url="${1}"
else
    url="$(gum input --placeholder='Enter URL')"
fi

wget --progress=bar "${base_url}?=${url}"
