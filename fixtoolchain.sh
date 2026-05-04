#!/bin/bash

# Automatyczne wykrywanie katalogu, w którym znajduje się skrypt
# Pozwala to na działanie skryptu niezależnie od nazwy folderu użytkownika
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ścieżka relatywna do toolchaina wewnątrz submodułu
# Zakładamy, że folder submodułu to buildroot-src
TOOLCHAIN_DIR="$PROJECT_ROOT/buildroot-src/output/host/opt/ext-toolchain/i486-linux-musl"

echo "-------------------------------------------------------"
echo "RGNX Toolchain Fixer"
echo "Project root: $PROJECT_ROOT"
echo "-------------------------------------------------------"

# 1. Sprawdzenie czy katalog docelowy istnieje
# Uwaga: Katalog ten pojawia się dopiero PO wypakowaniu toolchaina przez Buildroot
if [ ! -d "$TOOLCHAIN_DIR" ]; then
    echo "BŁĄD: Katalog toolchaina nie został jeszcze utworzony."
    echo "Ścieżka: $TOOLCHAIN_DIR"
    echo "Uruchom najpierw kompilację w Buildroot (make), aby pobrać toolchain."
    exit 1
fi

cd "$TOOLCHAIN_DIR" || exit 1

echo "Naprawa struktury w: $(pwd)"

# 2. Tworzenie katalogu usr
if [ ! -d "usr" ]; then
    echo "-> Tworzenie katalogu 'usr'..."
    mkdir -p usr
else
    echo "-> Katalog 'usr' już istnieje."
fi

# 3. Tworzenie symlinka usr/include -> ../include
if [ ! -L "usr/include" ]; then
    echo "-> Tworzenie dowiązania symbolicznego usr/include -> ../include..."
    ln -s ../include usr/include
    echo "-> Sukces!"
else
    echo "-> Symlink 'usr/include' już istnieje, pomijam."
fi

echo "-------------------------------------------------------"
echo "Gotowe. Struktura toolchaina jest poprawna."
