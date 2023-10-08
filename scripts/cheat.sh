#!/bin/sh

if [ ${#} -eq 0 ]
then
    curl -s cheat.sh | $PAGER
else
    curl -s cheat.sh/${@} | $PAGER
fi

