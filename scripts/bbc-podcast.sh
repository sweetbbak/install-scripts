#!/bin/bash
# list of bbc podcast episodes
list=$(
    curl -sL https://podcasts.files.bbci.co.uk/p02nq0gn.rss \
        | grep -m1 -oPm1 '(?<=enclosure url=")http://[^"]+.mp3'
)
