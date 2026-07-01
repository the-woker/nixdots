#!/bin/sh
cd ~/.config/quickshell/wallpaper/
nix-shell --run "quickshell -p Main.qml" &
