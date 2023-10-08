#!/bin/bash
# script to create a bootable Usb from a windows iso
ISO_MOUNT=/mnt/iso
FAT_MOUNT=/mnt/vfat
NTFS_MOUNT=/mnt/ntfs
FAT_SOURCES=$FAT_MOUNT/sources
BOOT_WIM=$ISO_MOUNT/sources/boot.wim
BOOT_SPACE=1GiB
INSTALL_SPACE=100%

if [ "$#" -ne 2 ]; then
    echo "Run the script:"
	echo "sudo ./flash.sh <DEVICE> <PATH_TO_WIN11_ISO>"
	echo "Example: sudo ./flash.sh /dev/sdb ~/Downloads/win11.iso"
	exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "Run this script as root"
    exit 2
fi

DEVICE_NAME=$1
WIN_ISO=$2

if [ ! -e $DEVICE_NAME ]; then
	echo "Device: '$DEVICE_NAME' does not exist"
	exit 3
fi

if [ ! -f $WIN_ISO ]; then
	echo "ISO not found: '$WIN_ISO'"
	exit 4
fi

echo "ISO: $WIN_ISO"
echo "Device   : $DEVICE_NAME (Data will be wiped)"
echo "Do you want to continue? (y/n)"
read CONTINUE

if [ "$CONTINUE" != "y" ]; then
	echo "Leaving ..."
	exit 0
fi

echo "Formating USB ..."
wipefs -a $DEVICE_NAME
echo "mklabel gpt" | parted $DEVICE_NAME
echo "mkpart BOOT fat32 0% $BOOT_SPACE" | parted $DEVICE_NAME
echo "mkpart INSTALL ntfs $BOOT_SPACE $INSTALL_SPACE" | parted $DEVICE_NAME
echo "unit B print" | parted $DEVICE_NAME
echo "USB formated"

echo "Mounting Windows ISO ..."
mkdir -p $ISO_MOUNT
mount $WIN_ISO $ISO_MOUNT/
echo "ISO mounted"

FAT32_PARTITION="$DEVICE_NAME"1
NTFS_PARTITION="$DEVICE_NAME"2
echo "FAT32 partition: $FAT32_PARTITION"
echo "NTFS partition : $NTFS_PARTITION"

echo "Formatting $FAT32_PARTITION partition and mounting ..."
mkfs.vfat -n BOOT $FAT32_PARTITION
mkdir -p $FAT_MOUNT
mount $FAT32_PARTITION $FAT_MOUNT/
echo "Formatted and mounted"

echo "Copying everything from the ISO image except the sources directory ..."
rsync -r --progress --exclude sources --delete-before $ISO_MOUNT/ $FAT_MOUNT/
echo "Files copied"

echo "Copying boot.wim ..."
mkdir -p $FAT_SOURCES
cp $BOOT_WIM $FAT_SOURCES/
echo "File copied"

echo "Formatting $NTFS_PARTITION partition and mounting ..."
mkfs.ntfs --quick -L INSTALL $NTFS_PARTITION
mkdir -p $NTFS_MOUNT
mount $NTFS_PARTITION $NTFS_MOUNT
echo "Formatted and mounted"

echo "Copying files from ISO ..."
rsync -r --progress --delete-before $ISO_MOUNT/ $NTFS_MOUNT/
echo "Files copied"

echo "Unmounting partitions ..."
echo "This may take a few minutes"
umount $NTFS_MOUNT
umount $FAT_MOUNT
umount $ISO_MOUNT
sync
echo "Partitions unmounted"

echo "Powering down the USB ..."
udisksctl power-off -b $DEVICE_NAME
echo "USB disabled"

echo "Flasing complete."
echo "You can disconnect the USB and boot from it."
