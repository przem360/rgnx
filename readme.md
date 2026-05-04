# RGNX Project - Custom Buildroot for Pentium II

This project contains a custom Linux system configuration built using Buildroot, optimized for i486/Pentium II architecture with SDL graphics support.

## 1. Building the Project from Scratch

To build the system in a clean environment (assuming Buildroot source is present), run the following commands:

```bash
# Clone this repository
git clone --recursive https://github.com/przem360/rgnx.git
cd rgnx

# Load the configuration file
make -C buildroot-src defconfig BR2_DEFCONFIG=../configs/rgnx_defconfig

# Build
make -C buildroot-src
```
Once the build is finished, the output files can be found in the output/images/ directory.

## 2. Configuration Management Rules

The project uses external configuration files stored in board/rgnx/. To ensure that your changes are persistent and not lost after a make clean or make distclean, always save them using the following rules:
Buildroot Configuration (Packages & System Settings)

    Edit: make menuconfig

    Save: make savedefconfig (updates configs/rgnx_defconfig)

Linux Kernel Configuration

    Edit: make linux-menuconfig

    Save: make linux-update-defconfig (updates board/rgnx/linux.config)

BusyBox Configuration

    Edit: make busybox-menuconfig

    Save: make busybox-update-config (updates board/rgnx/busybox.config)

## 3. Running in QEMU Emulator

To test the built image, use the following command (assuming you are in the Buildroot root directory):
```bash
qemu-system-i386 \
    -m 128M \
    -cpu pentium2-v1 \
    -kernel output/images/bzImage \
    -initrd output/images/rootfs.cpio.xz \
    -append "console=tty1"
```
## 4. Project Structure

`configs/rgnx_defconfig` - Main Buildroot configuration file.

`board/rgnx/linux.config` - Optimized Linux kernel configuration.

`board/rgnx/busybox.config` - BusyBox configuration (static, multiuser, shadow passwords).

`board/rgnx/rootfs-overlay/` - A directory whose content is copied directly to the target file system (use this for custom scripts and config files in /etc).

Note: Always ensure that BR2_ROOTFS_OVERLAY in menuconfig points to board/rgnx/rootfs-overlay to include your custom files in the final build.

## 5. Troubleshooting

Run `./fixtoolchain.sh` if include pathu issue will cause build failure.
