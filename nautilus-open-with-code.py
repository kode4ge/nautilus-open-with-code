# Copyright (c) 2025 KodeForge IT Solutions
# 
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

import logging as log
import os
import subprocess
import sys

from gi.repository import GObject, Nautilus


log.basicConfig(
    level=log.DEBUG,
    format='[%(asctime)s %(filename)s:%(lineno)s] %(levelname)s: %(message)s',
    stream=sys.stdout,
)

EXTENSION = 'OpenWithCodeExtension'
LABEL = 'Open with Code'
TIP = 'Open with VS Code'
CODE_NOT_FOUND = 'Could not execute VS Code'
ZENITY_NOT_FOUND = 'Could not execute Zenity'


class OpenWithCodeExtension(GObject.GObject, Nautilus.MenuProvider):
    """Nautilus extension to open folders/files with VS Code
 
    Adds a context menu entry in Nautilus to open files or folders with Visual Studio Code.
    """
    def show_error(self, message, title = 'Error'):
        try:
            subprocess.Popen(["zenity", f"--title={title}", "--error", "--no-wrap", "--text", message])
        except Exception as e:
            log.error(ZENITY_NOT_FOUND)

    def open_with_code(self, path):
        if os.getenv('NAUTILUS_DEBUG'):
            log.info('open_with_code() -> path: %s', path)

        try:
            subprocess.Popen(['code', path])
        except Exception as e:
            log.exception(CODE_NOT_FOUND)
            self.show_error(f'{CODE_NOT_FOUND}: {str(e)}')

    def launch_code(self, menu, file):
        self.open_with_code(file)

    def launch_code_from_background(self, menu, file):
        self.open_with_code(file)

    def get_file_items(self, window, files: list) -> list:
        if os.getenv('NAUTILUS_DEBUG'):
            log.info('get_file_items() -> files: %s',
                     [str(file.get_location().get_path()) for file in files])

        if len(files) != 1:
            return

        item = Nautilus.MenuItem(name=f'{EXTENSION}::OpenWithCode', label=LABEL, tip=TIP)
        item.connect('activate', self.launch_code, files[0].get_location().get_path())

        return [item]

    def get_background_items(self, window, file) -> list:
        if os.getenv('NAUTILUS_DEBUG'):
            log.info('get_background_items() -> file: %s', file.get_location().get_path())

        item = Nautilus.MenuItem(name=f'{EXTENSION}::OpenWithCodeBackground', label=LABEL, tip=TIP)
        item.connect('activate', self.launch_code_from_background, file.get_location().get_path())

        return [item]
