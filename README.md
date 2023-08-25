# So3 on Gem5 doc



## Gem5 environment

Pretty much followed this link, adapting to compile for ARM (https://www.gem5.org/getting_started/)

- Clone gem5 

  ```bash
  git clone https://github.com/gem5/gem5
  ```

- Build gem5 with the base configurations:

  ```bash
  cd gem5
  scons build/ARM/gem5.opt -j 4
  ```

- To test if the compilation went well:

  ```bash
  build/ARM/gem5.opt configs/learning_gem5/part1/simple-arm.py 
  # This is not a full system test so it's a good step, but not yet over
  ```

- Here's a basic script to run a full system: 

  ```bash
  ./build/ARM/gem5.opt \
  -d m5out_PCI \
  ./configs/example/fs.py \
  -n=1 \
  --machine-type=VExpress_GEM5_V1 \
  --cpu-type=AtomicSimpleCPU \
  --caches --l2cache \
  --kernel=vmlinux.arm64 \
  --disk-image=gem5_ubuntu16.img \
  --dtb-filename=$PWD/system/arm/dt/armv8_gem5_v1_1cpu.dtb 
  ```

  So to run this we need to setup a folder on the system that regroups the resources, the architecture should look like this : 

  ```bash
  __gem5-resources-full-system
    |
    |__disks
    |   |__sdcard.img.virt64
    |
    |__binaries
       |__so3 # Kernel binary, or any binary that must be launched (u-boot ?)
       |__boot.arm64 # Bootloader from gem5, maybe can be u-boot ?
  ```

  Then we need to export the environment variable so gem5 is not lost...

  ```bash
  # Example on my system
  export M5_PATH=/home/act-reds/projects/midgard/so3_gem5/so3-gem5/gem5-resources-full-system
  ```

  

## U-Boot on gem5

### Compile u-boot for ARM64

- Download U-boot

  ```bash
  git clone git@github.com:u-boot/u-boot.git
  ```

- Use a minimal ARM64 defconfig

  ```bash
  # make ARCH=arm sandbox_defconfig # -> Can't compile it, error
  make ARCH=arm rpi_arm64_defconfig
  ```

- Compile U-boot :

  ```bash
   make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm
  ```

  

## Create a disk image

#### 1. From so3 repo

To test this, I'll create a disk image with the scripts from so3 repo 

- Get so3 :

  ```bash
  git clone git@github.com:smartobjectoriented/so3.git
  ```

- Then create the image :

  ```bash
  cd so3/filesystem
  ./create_img.sh virt_64
  ```



#### 2. From command line

- Create the image :

  ```bash
  dd if=/dev/zero of=sdcard.img.so3gem5 bs="256M" count=1
  ```

- Mount image on loopback :If you want to check that you can mount the image and if you want to add things inside it: 

  ￼
  sudo mount /dev/loop32p1 /path/to/mountpoint
  # sudo mount /dev/loop32p1 /home/act-reds/test_mnt
  Remember to clean the reserved loop:

  ￼
  sudo losetup -d /dev/loop32
  After one of the two previous step, we will have an empty image correctly setup and usable with so3.

- 

  ```bash
  sudo losetup --partscan --find --show sdcard.img.so3gem5
  ```

  Get the output and save it for next step (let's say it's loop32 for this one, this will ease the documentation)

- Now we need to set the image the way we want : 

  ```bash
  sudo fdisk /dev/loop32
  
  ## Enter in Fdisk 
  ## o  -> New empty DOS partition table
  ## n  -> Add new partition
  ## p  -> print the partition table
  ##    -> Let the basic configuration
  ##    -> Let the basic configuration
  ##    -> Let the basic configuration
  ## t  -> Change the partition type
  ## c  -> Toggle the DOS compatibility flag
  ## w  -> Write table to disk and exit
  ```

- No change the partition format to fat32 so the bootloader can access it:

  ```bash
  sudo mkfs.fat -F32 -v /dev/loop32p1
  ```

- If you want to check that you can mount the image and if you want to add things inside it: 

  ```bash
  sudo mount /dev/loop32p1 /path/to/mountpoint
  # sudo mount /dev/loop32p1 /home/act-reds/test_mnt
  ```

- Remember to clean the reserved loop:

  ```bash
  sudo losetup -d /dev/loop32
  ```

After one of the two previous step, we will have an empty image correctly setup and usable with so3.



### Mount and unmount the image to modify it

Mount the image

```bash
# Disk image on loopback, sd cheating
sudo losetup --partscan --find --show sdcard.img.so3gem5

# Mount the partition needed on a mount point, the loop file is the output of previous
sudo mount /dev/loopXXp1 /path/to/mountpoint
# sudo mount /dev/loop32p1 /home/act-reds/test_mntmake -j4
```

-> Do whatever you need with the image

Then unmount the image: 

```bash
sudo umount /path/to/mountpoint
# sudo umount /home/act-reds/test_mnt

# Then free the loop reserved
sudo losetup -d /dev/loop32
```



## Compile So3

- Get So3 repo, set a config and cross-compile it for ARM64:

  ```bash
  git clone git@github.com:smartobjectoriented/so3.git
  cd so3
  make virt64_defconfig # Maybe test with another 
  make -j4
  ```

  
