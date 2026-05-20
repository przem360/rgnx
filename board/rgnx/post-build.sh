#!/usr/bin/env bash
set -e

echo "--- START: POST-BUILD SCRIPT ---"

# I don't want network anyway'
rm -f "${TARGET_DIR}/etc/init.d/S40network"

# Just to make sure that mountpoits exist
echo "Creating missing mountpoints..."
mkdir -p "${TARGET_DIR}/proc"
mkdir -p "${TARGET_DIR}/sys"
mkdir -p "${TARGET_DIR}/run"

# Silence S01seedring info
if [ -f "${TARGET_DIR}/etc/init.d/S01seedrng" ]; then
    echo "Forcing total silence on S01seedrng..."
    sed -i '2i exec >/dev/null 2>\&1' "${TARGET_DIR}/etc/init.d/S01seedrng"
fi

echo "--- END: POST-BUILD ---"
