# RGNX - Tiny Linux for retro gaming on old PCs

Buildroot Linux with SDL and emulators in under 10 MB.  
**This is work in progress experiment, it is not suitable for serious use.**

## Building the Project from Scratch

To build the system run the following commands:

```bash
# Clone this repository
git clone --recursive https://github.com/przem360/rgnx.git
cd rgnx

# Load the configuration file
make -C buildroot-src BR2_EXTERNAL=$(pwd) rgnx_defconfig

# Build
make -j$(nproc) -C buildroot-src BR2_EXTERNAL=$(pwd)
```
Once the build is finished, the output files can be found in the output/images/ directory.

## Install on the drive

```bash
sudo dd if=rgnx.img of=/dev/sdb bs=4M status=progress
```

## Running in QEMU Emulator

To test the built image, use the following command:

```bash
qemu-system-i386 \
    -m 128M \
    -cpu pentium2-v1 \
    -drive file=buildroot-src/output/images/rgnx_live.img,format=raw \
    -vga std
```
or:

```bash
qemu-system-i386 \
    -m 128M \
    -cpu pentium2-v1 \
    -device ahci,id=ahci \
    -drive file=buildroot-src/output/images/rgnx_disk.img,if=none,id=drive0,format=raw \
    -device ide-hd,drive=drive0,bus=ahci.0 \
    -vga std
```

## Configuration Management Rules

The project uses external configuration files stored in `board/rgnx/` and `configs/rgnx_defconf`. To ensure that your changes are persistent and not lost after a `make clean` or `make distclean`, always save them using the following rules:

### Buildroot Configuration (Packages & System Settings)

```bash
# Load configuration:
make -C buildroot-src BR2_EXTERNAL=$(pwd) rgnx_defconfig

# Edit via menuconfig
make -C buildroot-src BR2_EXTERNAL=$(pwd) menuconfig

# After saving in menuconfig, export changes to rgnx_defconfig
make -C buildroot-src BR2_EXTERNAL=$(pwd) savedefconfig

```

### Linux Kernel Configuration

```bash
# 1. Load the main project configuration first (if not already loaded)
make -C buildroot-src BR2_EXTERNAL=$(pwd) rgnx_defconfig

# 2. Edit Linux kernel via menuconfig
# This will use the path specified in BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE
make -C buildroot-src BR2_EXTERNAL=$(pwd) linux-menuconfig

# 3. After saving changes in the menu interface, 
# permanently update the config file in board/rgnx/linux.config
make -C buildroot-src BR2_EXTERNAL=$(pwd) linux-update-defconfig
```

### BusyBox Configuration

```bash
# 1. Load the main project configuration
make -C buildroot-src BR2_EXTERNAL=$(pwd) rgnx_defconfig

# 2. Edit BusyBox configuration via menuconfig
make -C buildroot-src BR2_EXTERNAL=$(pwd) busybox-menuconfig

# 3. Permanently save your BusyBox changes to the project
# Note: Ensure BR2_PACKAGE_BUSYBOX_CONFIG is set to point to your custom config file
make -C buildroot-src BR2_EXTERNAL=$(pwd) busybox-update-config
```

## Project Structure

`configs/rgnx_defconfig` - Main Buildroot configuration file.

`board/rgnx/linux.config` - Optimized Linux kernel configuration.

`board/rgnx/busybox.config` - BusyBox configuration (static, multiuser, shadow passwords).

`board/rgnx/rootfs-overlay/` - A directory whose content is copied directly to the target file system (use this for custom scripts and config files in /etc).

`board/rgnx/post-image.sh` - Building system images


## Clean
 
Run `make -C buildroot-src BR2_EXTERNAL=$(pwd) distclean` to clean.
