#!/bin/bash

# install the GET command to show ec2 device mapping
apt-get -y install libwww-perl

# unmount swap file if it exists
SWAP_FILE=/data1/swapfile
if [[ -f $SWAP_FILE ]]; 
	then
	swapoff $SWAP_FILE
fi

# unmount the first instance storage
if [[ -d /mnt ]];
	then
	umount /mnt
fi

rm -rf /mnt

# create partitions for disks
(echo n; echo p; echo 1; echo ; echo ; echo w) | fdisk /dev/xvdb
(echo n; echo p; echo 1; echo ; echo ; echo w) | fdisk /dev/xvdc
(echo n; echo p; echo 1; echo ; echo ; echo w) | fdisk /dev/xvdd
(echo n; echo p; echo 1; echo ; echo ; echo w) | fdisk /dev/xvde

# format them to ext4
mkfs -t ext4 -m 0 -O dir_index,extent,sparse_super /dev/xvdb1
mkfs -t ext4 -m 0 -O dir_index,extent,sparse_super /dev/xvdc1
mkfs -t ext4 -m 0 -O dir_index,extent,sparse_super /dev/xvdd1
mkfs -t ext4 -m 0 -O dir_index,extent,sparse_super /dev/xvde1

# create mounts
mkdir -p /data1
mkdir -p /data2
mkdir -p /data3
mkdir -p /data4

# update /etc/fstab
if [[ -f cloudera/files/fstab_worker ]];
	then
	mv /etc/fstab /etc/fstab.bak
	mv cloudera/files/fstab_worker /etc/fstab
fi

# mount them
mount /data1
mount /data2
mount /data3
mount /data4

# set up swap space (some ec2 instances do not have swap enabled by default)
# assumption: /mnt is already mounted and it's instance storage
if [[ `swapon -s | wc -l` == 1 ]] ;
	then
	echo "setting up swap space..."
	dd if=/dev/zero of=$SWAP_FILE bs=1M count=4096
	chmod 600 $SWAP_FILE
	mkswap $SWAP_FILE
	swapon $SWAP_FILE
fi
