#!/usr/bin/env bash

#set -x

PACKAGE_VERSION="0.1.0-alpha"
PACKAGE_NAME="nautilus-open-with-code"
PACKAGE_FULL_NAME="${PACKAGE_NAME}_${PACKAGE_VERSION}"
STAGE_DIR="./stage"
DIST_DIR="./dist"
DEBIAN_DIR="$STAGE_DIR/$PACKAGE_FULL_NAME/DEBIAN"
INSTALL_DIR="$STAGE_DIR/$PACKAGE_FULL_NAME/usr/share/nautilus-python/extensions"
MAINTAINER="${NAUTILUS_OPEN_WITH_CODE_MAINTAINER}"
HOMEPAGE="https://github.com/kode4ge/nautilus-open-with-code"

echo "[*] Preparing package structure..."
rm -rf "$STAGE_DIR/$PACKAGE_FULL_NAME"
mkdir -p "$DIST_DIR" "$DEBIAN_DIR" "$INSTALL_DIR"

echo "[*] Copying source-code..."
cp "${PACKAGE_NAME}.py" "$INSTALL_DIR"
chmod 644 "$INSTALL_DIR/${PACKAGE_NAME}.py"

echo "[*] Preparing package metadata..."
tee "$DEBIAN_DIR/control" > /dev/null <<EOF
Package: $PACKAGE_NAME
Version: $PACKAGE_VERSION
Section: utils
Priority: optional
Architecture: all
Depends: python3, python3-nautilus, zenity
Recommends: code
Maintainer: $MAINTAINER
Description: Nautilus extension to open folders/files with VS Code
 Adds a context menu entry in Nautilus to open files or folders with Visual Studio Code.
Homepage: $HOMEPAGE
EOF

echo "[*] Calculating installation size..."
echo "Installed-Size: $(du -s --apparent-size --block-size=1024 "$INSTALL_DIR" | cut -f1)" >> "$DEBIAN_DIR/control"

chmod -R 755 "$DEBIAN_DIR"

echo "[*] Preparing post installation script..."
tee "$DEBIAN_DIR/postinst" > /dev/null << "EOF"
#!/usr/bin/env bash

#set -x

echo "[*] Reloading Nautilus to apply the extension..."

USER_NAME=$(logname)

# Terminates user's Nautilus
sudo -u "$USER_NAME" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER_NAME")/bus nautilus --quit

sleep 2

# Restarts Nautilus in background
sudo -u "$USER_NAME" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER_NAME")/bus setsid nautilus >/dev/null 2>&1 &

exit 0
EOF

chmod 755 "$DEBIAN_DIR/postinst"

echo "[*] Preparing post uninstallation script..."
tee "$DEBIAN_DIR/postrm" > /dev/null << "EOF"
#!/usr/bin/env bash

#set -x

USER_NAME=$(logname)

echo "[*] Reloading Nautilus to unload the extension..."

# Terminates user's Nautilus
sudo -u "$USER_NAME" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER_NAME")/bus nautilus --quit

sleep 2

# Restarts Nautilus in background
sudo -u "$USER_NAME" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER_NAME")/bus setsid nautilus >/dev/null 2>&1 &

exit 0
EOF

chmod 755 "$DEBIAN_DIR/postrm"

echo "[*] Finally building package..."
dpkg-deb --build "$STAGE_DIR/$PACKAGE_FULL_NAME" "$DIST_DIR/${PACKAGE_FULL_NAME}.deb"

# if [[ "$1" == "--publish" ]]; then
#     if ! command -v gh > /dev/null 2&>1; then
#         echo "[!] GitHub CLI (gh) is not installed. Please install it to use the \`--publish\` option."
#         exit 1
#     fi

#     echo "[*] Publishing release on GitHub..."
#     gh release create "v$PACKAGE_VERSION" "$PACKAGE_FULL_NAME.deb" \
#         --title "$PACKAGE_NAME v$PACKAGE_VERSION" \
#         --notes "Release $PACKAGE_NAME v$PACKAGE_VERSION"
# fi

exit 0
