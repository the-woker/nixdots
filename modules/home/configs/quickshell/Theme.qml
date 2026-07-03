import QtQuick

QtObject {
    readonly property color bgBase: "#111111"
    readonly property color bgSurface: "#24283b"
    readonly property color bgOverlay: "#88000000"
    readonly property color bgHover: "#1e2235"
    readonly property color bgSelected: "#474542"
    readonly property color bgBorder: "#32364a"
    readonly property color textPrimary: "#c0caf5"
    readonly property color textSecondary: "#a9b1d6"
    readonly property color textMuted: "#565f89"

    readonly property color accentPrimary: "#F3ABB9"
    // readonly property color accentPrimary: "#FFFF01"
    // readonly property color accentPrimary: "#FF8704"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
}
