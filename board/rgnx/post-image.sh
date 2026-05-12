#!/usr/bin/env bash
set -e

BOARD_DIR="$(dirname $0)"
# Ścieżka do plików wyjściowych Buildroota
IMAGES_DIR="${BINARIES_DIR}"

# 1. Przygotuj syslinux.cfg bezpośrednio w folderze images
cat > "${IMAGES_DIR}/syslinux.cfg" << EOF
DEFAULT rgnx
LABEL rgnx
  SAY [ BOOTING RGNX SYSTEM FROM IMAGE ]
  KERNEL bzImage
  INITRD rootfs.cpio.xz
  APPEND root=/dev/ram0 rw initrd=rootfs.cpio.xz console=tty1 vga=0x344 loglevel=3
EOF

# 2. Stwórz pusty plik obrazu (np. 32MB)
# 32768 blocks * 1k = 32MB
dd if=/dev/zero of="${IMAGES_DIR}/rgnx.img" bs=1k count=32768

# 3. Sformatuj plik jako FAT (używamy mkfs.vfat z hosta)
mkfs.vfat -n "RGNX" "${IMAGES_DIR}/rgnx.img"

# 4. Zainstaluj bootloader Syslinux w obrazie (VBR)
syslinux --install "${IMAGES_DIR}/rgnx.img"

# 5. Skopiuj pliki do obrazu przy użyciu mcopy (z pakietu mtools)
# Dzięki mcopy nie musimy montować obrazu (brak sudo!)
mcopy -i "${IMAGES_DIR}/rgnx.img" "${IMAGES_DIR}/bzImage" ::/bzImage
mcopy -i "${IMAGES_DIR}/rgnx.img" "${IMAGES_DIR}/rootfs.cpio.xz" ::/rootfs.cpio.xz
mcopy -i "${IMAGES_DIR}/rgnx.img" "${IMAGES_DIR}/syslinux.cfg" ::/syslinux.cfg

# 6. (Opcjonalnie) Dodaj kod MBR na początku pliku
# Jeśli nie masz mbr.bin, QEMU i tak powinno ruszyć w trybie 'floppy'
MBR_PATH=$(find /usr/lib -name "mbr.bin" | grep bios | head -n 1)
if [ -n "$MBR_PATH" ]; then
    dd if="$MBR_PATH" of="${IMAGES_DIR}/rgnx.img" bs=440 count=1 conv=notrunc
fi

echo "---------------------------------------"
echo "Obraz rgnx.img został zbudowany pomyślnie!"
echo "---------------------------------------"
