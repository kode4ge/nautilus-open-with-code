#!/usr/bin/env bash

#set -x

EXTENSION="nautilus-open-with-code.py"
INSTALL_DIR="$HOME/.local/share/nautilus-python/extensions/"

if [ ! -d "$INSTALL_DIR" ]; then
    echo "[*] Creating destination directory \"$INSTALL_DIR\" ..."
    mkdir -p "$INSTALL_DIR"
fi

echo '[*] Installing extension...'
cp "$EXTENSION" "$INSTALL_DIR"

echo '[*] Restarting Nautilus in debug mode ...'
nautilus -q

echo '3...'
sleep 1

echo '2...'
sleep 1

echo '1...'
sleep 1

NAUTILUS_DEBUG=1 nautilus
