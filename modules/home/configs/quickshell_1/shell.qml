import Quickshell
import Quickshell.Io
import QtQuick
import "bar"
import "app-launcher"
import "wallpaper"

Scope {
    readonly property var theme: Theme {}
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
