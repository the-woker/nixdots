import QtQuick

QtObject {
    property string currentWallpaper: ""

    readonly property color bgBase: "#111111"
    readonly property color bgSurface: "#24283b"
    readonly property color bgOverlay: "#88000000"
    readonly property color bgHover: "#1e2235"
    readonly property color bgSelected: "#474542"
    readonly property color bgBorder: "#32364a"
    readonly property color textPrimary: "#c0caf5"
    readonly property color textSecondary: "#a9b1d6"
    readonly property color textMuted: "#565f89"

readonly property color accentPrimary: {
        var cleanPath = currentWallpaper.trim();
        
        var colors = {
            "ichigo.jpg": "#FF8704",
            "bleach.jpeg": "#FF8704",
            "bleach2.jpg": "#FF8704",
            "bleach3.jpg": "#FF8704",
            "rukia.jpg": "#80A2CF",
            "rukia2.png": "#FF8704",
            "moon.png": "#FFFF01",
            "ranni.jpeg": "#80A2CF",
            "ranni3.png": "#80A2CF",
            "kessoku.png": "#F3ABB9",
            "katanazero.png": "#58377F",
            "katanazero.jpg": "#58377F",
            "ed.jpg": "#BF252D",
            "ed2.jpg": "#E6C345",
            "ed3.png": "#9A3537",
            "philedelphia.jpg": "#BF252D",
            "silverdick.jpg": "#446D99",
            "goku.jpg": "#FFA93A"
        };

        for (var key in colors) {
            if (cleanPath.endsWith(key)) {
                return colors[key];
            }
        }
        return textPrimary; // Fallback
    }

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
}
