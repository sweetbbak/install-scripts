#!/bin/zsh

if [[ -z $1 ]]; then
    echo "Usage: $0 URL";
else
    curl "http://web.archive.org/cdx/search/cdx?url=$1/*&output=json&fl=original,timestamp" 2> /dev/null | jq '.[1:][] |"https://web.archive.org/web/" +.[1] + "/" + .[0]' 2> /dev/null;
fi
