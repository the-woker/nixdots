import Quickshell
import Quickshell.Io
import QtQuick
import "bar"
import "app-launcher"
import "wallpaper"

Scope {
    Bar {}
    AppLauncher {
        theme: ts.theme
    }
    WallpaperManager {
        theme: ts.theme
    }
}
