#!/usr/bin/env bash
set -e

IMG_DIR="${BINARIES_DIR}"
BOARD_DIR="$(dirname "$0")"

LIVE_IMG="${IMG_DIR}/rgnx_live.img"
DISK_IMG="${IMG_DIR}/rgnx_disk.img"
BOOT_VFAT="${IMG_DIR}/boot.vfat"
ROOT_EXT4="${IMG_DIR}/rootfs.ext4"

# Rozmiary
BOOT_SIZE=64 
DISK_TOTAL_SIZE=450

echo "--- START: RGNX IMAGE GENERATOR (PARTUUID FIX) ---"

cat > "${IMG_DIR}/syslinux_live.cfg" << EOF
DEFAULT rgnx
LABEL rgnx
  SAY [ BOOTING RGNX LIVE ]
  KERNEL bzImage
  INITRD rootfs.cpio.xz
  APPEND console=tty1 vga=0x344 loglevel=2 root=/dev/ram0 rw
EOF

echo "Building: rgnx_live.img..."
dd if=/dev/zero of="${LIVE_IMG}" bs=1M count=48
mkfs.vfat -F 16 -n "RGNX_LIVE" "${LIVE_IMG}"
syslinux --install "${LIVE_IMG}"
mcopy -i "${LIVE_IMG}" "${IMG_DIR}/bzImage" ::/bzImage
mcopy -i "${LIVE_IMG}" "${IMG_DIR}/rootfs.cpio.xz" ::/rootfs.cpio.xz
mcopy -i "${LIVE_IMG}" "${IMG_DIR}/syslinux_live.cfg" ::/syslinux.cfg

echo "Building: rgnx_disk.img..."

dd if=/dev/zero of="${DISK_IMG}" bs=1M count=${DISK_TOTAL_SIZE}

# Partitioning
# Set constant label-id, it seems to fixt mounting issue
DISK_ID="c2af988a"

sfdisk "${DISK_IMG}" << EOF
label: dos
label-id: 0x${DISK_ID}
unit: sectors
2048, $((BOOT_SIZE * 2048)), 0c, *
$((BOOT_SIZE * 2048 + 2048)), , 83
EOF

cat > "${IMG_DIR}/syslinux_disk.cfg" << EOF
DEFAULT rgnx
LABEL rgnx
  SAY [ BOOTING RGNX FROM DISK (PARTUUID) ]
  KERNEL bzImage
  APPEND console=tty1 vga=0x344 loglevel=2 root=PARTUUID=${DISK_ID}-02 rw rootwait rootfstype=ext4 init=/sbin/init
EOF

mformat -i "${DISK_IMG}@@1M" -F -v "RGNX_BOOT" -t ${BOOT_SIZE} -h 64 -s 32

mcopy -i "${DISK_IMG}@@1M" "${IMG_DIR}/bzImage" ::/bzImage
mcopy -i "${DISK_IMG}@@1M" "${IMG_DIR}/syslinux_disk.cfg" ::/syslinux.cfg

# Insert rootfs to the second partition
dd if="${ROOT_EXT4}" of="${DISK_IMG}" bs=1M seek=$((BOOT_SIZE + 1)) conv=notrunc

# Installing Syslinux in the VBR
syslinux --install --offset $((2048 * 512)) "${DISK_IMG}"

# Installing MBR
MBR_PATH=$(find /usr/lib -name "mbr.bin" | grep -i "bios" | head -n 1)
[ -z "$MBR_PATH" ] && MBR_PATH="/usr/lib/syslinux/mbr/mbr.bin"

if [ -f "$MBR_PATH" ]; then
    dd if="$MBR_PATH" of="${DISK_IMG}" bs=440 count=1 conv=notrunc
    echo "Applied MBR: $MBR_PATH"
else
    echo "ERROR: Could not find mbr.bin!"
fi

echo "--- DONE. ---"
