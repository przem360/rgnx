#!/bin/sh
TARGET_DIR=$1

echo "=== RGNX Post-Build: Cleaning rootfs ==="

# ALL .GZ FONTS
if [ -d "${TARGET_DIR}/usr/share/consolefonts" ]; then
    echo "Removing .gz from /usr/share/consolefonts/"
    find "${TARGET_DIR}/usr/share/consolefonts" -type f -name "*.gz" -delete
fi

# ALL NON CUSTOM KEY MAPS
if [ -d "${TARGET_DIR}/usr/share/keymaps" ]; then
    echo "Removing dir: /usr/share/keymaps/"
    rm -rf "${TARGET_DIR}/usr/share/keymaps"
fi

# ALL TRANSLATION TABLES
if [ -d "${TARGET_DIR}/usr/share/consoletrans" ]; then
    echo "Removing dir: /usr/share/consoletrans/"
    rm -rf "${TARGET_DIR}/usr/share/consoletrans"
fi

# ALL UNIMAPS
if [ -d "${TARGET_DIR}/usr/share/unimaps" ]; then
    echo "Removing dir: /usr/share/consoletrans/"
    rm -rf "${TARGET_DIR}/usr/share/consoletrans"
fi

# ALSA SOUNDS
if [ -d "${TARGET_DIR}/usr/share/unimaps" ]; then
    echo "Removing ALSA sounds:"
    rm -rf "${TARGET_DIR}/usr/share/sounds"
fi

# READMEs
echo "Removing README files..."
find "${TARGET_DIR}" -type f -name "README*" -delete

# CHANGELOGs and MANs
echo "Removing changelogs and man pages..."
find "${TARGET_DIR}" -type f -name "CHANGELOG*" -delete
if [ -d "${TARGET_DIR}/usr/share/man" ]; then
    rm -rf "${TARGET_DIR}/usr/share/man"
fi

# SDLGNUBOY binary
echo "Removing sdlgnuboy binary (for now)..."
find "${TARGET_DIR}/usr/bin/" -type f -name "sdlgnuboy" -delete

echo "=== Done. ==="
