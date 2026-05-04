#!/bin/bash

# Definicja ścieżki (wyciągnięta do zmiennej, aby łatwo było ją zmienić)
TOOLCHAIN_DIR="/home/pw/rgnx_buildroot/buildroot-2026.02.1/output/host/opt/ext-toolchain/i486-linux-musl"

echo "Rozpoczynam naprawę struktury toolchaina dla Buildroot..."

# 1. Sprawdzenie czy katalog docelowy w ogóle istnieje
if [ ! -d "$TOOLCHAIN_DIR" ]; then
    echo "BŁĄD: Katalog $TOOLCHAIN_DIR nie istnieje!"
    exit 1
fi

cd "$TOOLCHAIN_DIR" || exit 1

# 2. Tworzenie katalogu usr (jeśli nie istnieje)
if [ ! -d "usr" ]; then
    echo "Tworzenie katalogu 'usr'..."
    mkdir -p usr
else
    echo "Katalog 'usr' już istnieje."
fi

# 3. Tworzenie symlinka
if [ ! -L "usr/include" ]; then
    echo "Tworzenie dowiązania symbolicznego usr/include -> ../include..."
    ln -s ../include usr/include
    echo "Sukces!"
else
    echo "Symlink 'usr/include' już istnieje, pomijam."
fi

echo "Gotowe. Możesz teraz spróbować uruchomić 'make linux-menuconfig' w Buildroot."
