#!/bin/bash
printf "\e[3;33;3%s\3[0m\n" "This script tests a CPU at low stress for a long duration using dd and a fake disk image"

# define the path to store the image, recommended to be a tmpfs mounted location to avoid read/writes
img=/scratch/image.img

# define the mount point
mnt=/mnt/loop

# size of time arg to pass to truncate, make sure you select something less than the free memory on the system
# see truncate --help for available options
size=40G

# defaults to 1 less than the number of virtual cores, manually redefine if desired
max=$(($(nproc) - 1))

if [[ ! -f $img ]]; then
  truncate -s $size $img
  mkfs.ext4 $img
  [[ -d $mnt ]] || mkdir -p $mnt
  if ! mountpoint -q $mnt; then
    mount -o loop $img $mnt || exit 1
  fi
fi

for i in $(eval echo "{0..$max}"); do
  echo "using core $i of $max"
  taskset -c "$i" time dd if=/dev/zero of=$mnt/zerofill status=progress
done

umount $mnt
rm $img

