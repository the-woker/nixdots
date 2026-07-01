import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: panel

    property color colBg: "#151515"
    property color colMuted: "#444b6a"
    property color colRed: "#FEFF01"
    property string fontFamily: "CaskaydiaCove Nerd Font Mono"
    property int fontSize: 14

    property int activeTag: 1
    property int memUsage: 0
    property string activeWindow: "Window"
    property string currentLayout: "Tile"
    property string currentTime: Qt.formatDateTime(new Date(), "HH:mm")

    color: "transparent"
    mask: null
    implicitHeight: 30

    anchors {
        top: true
        left: true
        right: true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                panel.memUsage = Math.round(100 * used / total);
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: windowProc
        command: ["sh", "-c", "mmsg get focusing-client | jq -r '.title // empty'"]
        stdout: SplitParser {
            onRead: data => {
                if (data && data.trim()) {
                    panel.activeWindow = data.trim();
                }
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: tagsProc
        command: ["sh", "-c", "mmsg watch all-tags"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                try {
                    let obj = JSON.parse(data);
                    let monitors = obj.all_tags || [];

                    for (let mon of monitors) {
                        if (mon.monitor === panel.screen.name) {
                            let active = mon.tags.find(t => t.is_active);
                            if (active) {
                                panel.activeTag = active.index;
                            }
                            return;
                        }
                    }
                } catch (e) {
                    console.log(e);
                }
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            memProc.running = true;
            windowProc.running = true;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            panel.currentTime = Qt.formatDateTime(new Date(), "HH:mm");
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 10

        Rectangle {
            id: workspaces
            implicitWidth: 200
            implicitHeight: 24
            color: panel.colBg
            radius: 12

            RowLayout {
                anchors.centerIn: parent
                spacing: 5

                Repeater {
                    model: 9
                    Rectangle {
                        width: 12
                        height: 12
                        color: "transparent"
                        property bool isActive: panel.activeTag === index + 1

                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            font.family: panel.fontFamily
                            font.pixelSize: 12
                            color: parent.isActive ? panel.colRed : panel.colMuted
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            id: clock
            implicitWidth: 150
            implicitHeight: 24
            color: panel.colBg
            radius: 12

            Text {
                anchors.centerIn: parent
                text: panel.currentTime
                font.family: panel.fontFamily
                font.pixelSize: panel.fontSize
                color: panel.colRed
                font.bold: true
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            id: memory
            Layout.preferredWidth: workspaces.implicitWidth
            implicitHeight: 24
            color: "transparent"

            Rectangle {
                anchors.right: parent.right
                implicitWidth: 80
                implicitHeight: 24
                color: panel.colBg
                radius: 12

                Text {
                    anchors.centerIn: parent
                    text: "RAM: " + panel.memUsage + "%"
                    font.family: panel.fontFamily
                    font.pixelSize: panel.fontSize
                    color: panel.colRed
                    font.bold: true
                }
            }
        }
    }
}
