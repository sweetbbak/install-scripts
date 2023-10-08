#!/bin/bash
arp -an | grep "$(sudo virsh dumpxml win10 | grep "mac address" | awk -F\' '{print $2}')"
