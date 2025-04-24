# Nautilus: Open with Code

[![Nautilus Extension](https://img.shields.io/badge/Nautilus-Extension-brightgreen)](https://wiki.gnome.org/Apps/Files)
[![Made with Python](https://img.shields.io/badge/Made%20with-Python-blue?logo=python)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-alpha-orange)](https://github.com/kode4ge/nautilus-open-with-code/releases/tag/v0.1.0-alpha)

A simple Nautilus extension that adds an **“Open with Code”** context menu item for folders.


## 🚀 Features

- Right-click on any folder and open it in **Visual Studio Code**.
- Clean and minimal Python code.


## 📝 TODO

- Test `.deb` package on a VM in order to check if the dependencies, including VS Code, are automatically installed.


## 🛠️ Tags and releases

```
git tag -a v0.1.0-alpha -m "Note: Not meant for production yet"
git show v0.1.0-alpha
git push origin --tags
gh release create v0.1.0-alpha ./dist/nautilus-open-with-code_0.1.0-alpha.deb --prerelease --title "nautilus-open-with-code v0.1.0-alpha" --notes "Not meant for production use yet."
```
