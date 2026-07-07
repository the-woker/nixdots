import Quickshell
import Quickshell.Io
import QtQuick
import "bar"
import "launcher"
import "wallpaper"

Scope {
    id: rootShell

    FileView {
        id: wallpaperFile
        path: "/home/ratjerky/nixdots/modules/home/configs/quickshell/wallpaper.conf"
        watchChanges: true

        onFileChanged: reload()
    }

    readonly property var globalTheme: Theme {
        currentWallpaper: wallpaperFile.text()
    }

    AppLauncher {
        id: launcher
    }
    Bar {
        id: topBar
    }
    WallpaperManager {
        id: wallpaper
    }
}
