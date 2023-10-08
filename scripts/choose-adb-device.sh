#!/bin/bash

adb devices | grep -w 'device' | sed -e 's/device//g' -e 's/^[[:space:]]//g' | gum choose
