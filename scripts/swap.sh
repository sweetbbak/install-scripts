#!/bin/bash

if [ ! -d /swap ]; then
    fallocate -l 4G /swap
    chmod 600 /swap
    mkswap /swap
    swapon /swap
else
    # off
    [ -d /swap ] && {
        swapoff /swap
        rm -fv /swap
    }
fi