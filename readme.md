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

## Running in QEMU Emulator

To test the built image, use the following command:
```bash
qemu-system-i386 \
    -m 128M \
    -cpu pentium2-v1 \
    -kernel buildroot-src/output/images/bzImage \
    -initrd buildroot-src/output/images/rootfs.cpio.xz \
    -append "console=tty1 vga=0x344" \
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
Note: After updating the kernel configuration, you don't need to rebuild the entire project from scratch. Simply run the build command again:

```bash
make -C buildroot-src BR2_EXTERNAL=$(pwd)
```

Buildroot will automatically detect the configuration changes, reconfigure the kernel, and recompile only the necessary components before updating the final system image.

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
Note: Just like with the kernel, after saving your changes, simply run the main build command to apply them:

```bash
make -C buildroot-src BR2_EXTERNAL=$(pwd)
```

## Project Structure

`configs/rgnx_defconfig` - Main Buildroot configuration file.

`board/rgnx/linux.config` - Optimized Linux kernel configuration.

`board/rgnx/busybox.config` - BusyBox configuration (static, multiuser, shadow passwords).

`board/rgnx/rootfs-overlay/` - A directory whose content is copied directly to the target file system (use this for custom scripts and config files in /etc).

Note: Always ensure that BR2_ROOTFS_OVERLAY in menuconfig points to board/rgnx/rootfs-overlay to include your custom files in the final build.

## 5. Troubleshooting

Run `./fixtoolchain.sh` if include pathu issue will cause build failure.  
Run `make -C buildroot-src BR2_EXTERNAL=$(pwd) distclean` to clean.
