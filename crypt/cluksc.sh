#!/bin/bash
#
# Parameters: <filename> <size_in_bytes> <filesystem> <mapper_name>
#
# cluksc.sh Create luks container
# --
# Steps
# 0 Init stuff, set defaults
# 1 create the file: fallocate -l <size_in_bytes> <filename>
# 2 mount the file on loopback device
#   sudo losetup -f for first available loopback device
#   sudo losetup <loopback_device> <filename>
# 3 create the luks device: sudo cryptsetup luksFormat <loopback_device>
# 4 open the new encrypted container: sudo cryptsetup luksOpen <loopback_device> <mapper_name>
# 5 format the container: sudo mkfs.<filesysytem> /dev/mapper/<mapper_name>
# 6 close the container: sudo cryptsetup luksClose <mapper_name>
#
filename=${1-cluksc.lvl}
size_in_bytes=${2-10000000000}
filesystem=${3-vfat}
mapper_name=${4-cluksc}
mapper_path="/dev/mapper"
#
if [[ $(fallocate -l $size_in_bytes $filename) -ne 0 ]]
  then echo "fallocate failed"
  exit
fi
#
loopback_device=$(sudo losetup -f)
if [[ -z "${loopback_device}" ]]
  then echo "no loopback device available"
  exit
fi
#
if [[ $(sudo losetup $loopback_device $filename) -ne 0 ]]
  then echo "loopback mount failed"
  exit
fi
#
sudo cryptsetup luksFormat $loopback_device
#
if [[ $(sudo losetup -d $loopback_device)  ]]
  then echo "removing loopback device failed"
  exit
fi
#
if [[ $(sudo cryptsetup luksOpen $filename $mapper_name) -ne 0 ]]
  then echo "cryptsetup luksOpen failed"
  exit
fi
#
sudo mkfs.$filesystem "$mapper_path/$mapper_name"
#
if [[ $(sudo cryptsetup luksClose $mapper_name) -ne 0 ]]
  then echo "cryptsetup luksClose failed"
  exit
fi
