echo Creating sdcard.img.virt64 ... 
dd_size=256M
dd if=/dev/zero of=sdcard.img.virt64 bs="$dd_size" count=1
devname=$(sudo losetup --partscan --find --show sdcard.img.virt64)

devname=${devname#"/dev/"}

(echo o; echo n; echo p; echo; echo; echo; echo t; echo c; echo w) | sudo fdisk /dev/"$devname";

echo Waiting...
sleep 2s

sudo mkfs.fat -F32 -v /dev/"$devname"p1

sudo losetup -d /dev/"$devname"

