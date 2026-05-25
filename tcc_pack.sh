#!/bin/sh
set -e

BASE_DIR="/home/pw/rgnx/buildroot-src"
TCC_SRC="${BASE_DIR}/output/build/tcc"
PACK_DIR="tcc_package"

TOOLCHAIN_SYSROOT="${BASE_DIR}/output/host/opt/ext-toolchain/i486-linux-musl"
BUILDROOT_SYSROOT="${BASE_DIR}/output/host/i486-buildroot-linux-musl/sysroot"

echo "=== Preparing rootfs structure for TCC ==="
rm -rf "$PACK_DIR"
mkdir -p "$PACK_DIR/usr/bin"
mkdir -p "$PACK_DIR/usr/lib/tcc/include"
mkdir -p "$PACK_DIR/usr/include"

echo "Copying TCC..."
cp "$TCC_SRC/tcc" "$PACK_DIR/usr/bin/"
cp "$TCC_SRC/libtcc1.a" "$PACK_DIR/usr/lib/tcc/"
cp "$TCC_SRC"/include/*.h "$PACK_DIR/usr/lib/tcc/include/" 2>/dev/null || true

echo "Copying crt files..."
cp "$TOOLCHAIN_SYSROOT/lib"/crt*.o "$PACK_DIR/usr/lib/"

echo "Copying static libs..."
cp "$TOOLCHAIN_SYSROOT/lib"/lib*.a "$PACK_DIR/usr/lib/"

echo "Copying headers..."
cp -r "$TOOLCHAIN_SYSROOT/include"/* "$PACK_DIR/usr/include/"
if [ -d "$BUILDROOT_SYSROOT/usr/include" ]; then
    cp -r -n "$BUILDROOT_SYSROOT/usr/include"/* "$PACK_DIR/usr/include/" 2>/dev/null || true
fi

echo "Creating archive..."
tar -cf - -C "$PACK_DIR" usr | gzip -9 > tcc.tar.gz

rm -rf "$PACK_DIR"

echo "Generating install.sh..."
cat << 'EOF' > install.sh
#!/bin/sh
set -e

echo "=== Installing TCC ==="
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ARCHIVE="$SCRIPT_DIR/tcc.tar.gz"

if [ ! -f "$ARCHIVE" ]; then
    echo "ERROR: Missing tcc.tar.gz file!"
    exit 1
fi

echo "Extracting..."
gunzip -c "$ARCHIVE" | tar -xf - -C /

echo "chmod..."
chmod +x /usr/bin/tcc

# FIX LINKER ISSUE:
echo "Making C library symlinks for TCC..."
rm -f /usr/lib/libc.so
ln -sf /lib/ld-musl-i386.so.1 /usr/lib/libc.so

echo "==== Done. ===="
EOF
chmod +x install.sh

echo "==== Done. ===="
