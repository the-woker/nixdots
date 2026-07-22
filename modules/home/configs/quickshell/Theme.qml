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

        if (cleanPath.endsWith("ichigo.jpg")) {
            return "#FF8704";
        } else if (cleanPath.endsWith("bleach.jpeg")) {
            return "#FF8704";
        } else if (cleanPath.endsWith("bleach2.jpg")) {
            return "#FF8704";
        } else if (cleanPath.endsWith("bleach3.jpg")) {
            return "#FF8704";
        } else if (cleanPath.endsWith("rukia.jpg")) {
            return "#80A2CF";
        } else if (cleanPath.endsWith("rukia2.png")) {
            return "#FF8704";
        } else if (cleanPath.endsWith("moon.png")) {
            return "#FFFF01";
        } else if (cleanPath.endsWith("ranni.jpeg")) {
            return "#80A2CF";
        } else if (cleanPath.endsWith("ranni2.png")) {
            return "#80A2CF";
        } else if (cleanPath.endsWith("ranni3.png")) {
            return "#80A2CF";
        } else if (cleanPath.endsWith("kessoku.png")) {
            return "#F3ABB9";
        } else if (cleanPath.endsWith("katanazero.png")) {
            return "#58377F";
        } else if (cleanPath.endsWith("ed.jpg")) {
            return "#BF252D";
        } else if (cleanPath.endsWith("ed2.jpg")) {
            return "#E6C345";
        } else if (cleanPath.endsWith("ed3.png")) {
            return "#9A3537";
        } else if (cleanPath.endsWith("philedelphia.jpg")) {
            return "#BF252D";
        } else if (cleanPath.endsWith("silverdick.jpg")) {
            return "#446D99";
        }
    }

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
}
