pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var wallpapers: [] // Changed from list<string> to var for clean JS array manipulation
    property string currentWallpaper: ""
    property string backend: "awww"

    // Temporary holder array to prevent QML binding thrashing
    property var _tempWallpapers: []

    Process {
        id: scanner
        command: ["sh", "-c", "find ~/Pictures/Wallpapers ~/Pictures -maxdepth 2 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \\) 2>/dev/null | sort -u | head -200"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                const path = data.trim();
                if (path !== "") {
                    root._tempWallpapers.push(path);
                }
            }
        }
        // Efficiently assign everything at once when find is finished
        onExited: (exitCode, exitStatus) => {
            root.wallpapers = root._tempWallpapers;
        }
    }

    // Load saved wallpaper path using Quickshell's Process instead of an ambiguous FileView
    Process {
        id: configLoader
        command: ["sh", "-c", "cat $HOME/.config/quickshell/wallpaper.conf 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const saved = data.trim();
                if (saved !== "")
                    root.currentWallpaper = saved;
            }
        }
    }

    Component.onCompleted: {
        rescan();
    }

    function rescan() {
        root.wallpapers = [];
        root._tempWallpapers = [];
        scanner.running = true;
    }

    function setWallpaper(path) {
        currentWallpaper = path;

        // Run awww with your configured transition arguments
        setProcess.command = ["awww", "img", path, "--transition-type", "grow", "--transition-pos", "center", "--transition-duration", "1"];
        setProcess.running = true;

        // Save to configuration file
        saveProcess.command = ["sh", "-c", 'mkdir -p "$HOME/.config/quickshell" && printf "%s" "$1" > "$HOME/.config/quickshell/wallpaper.conf"', "sh", path];
        saveProcess.running = true;
    }

    Process {
        id: setProcess
        command: []
        running: false
    }

    Process {
        id: saveProcess
        command: []
        running: false
    }
}
