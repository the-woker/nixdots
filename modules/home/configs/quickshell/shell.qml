import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "app-launcher"

ShellRoot {
    id: root

    AppLauncher {}
    property color colBg: "#151515"
    property color colMuted: "#444b6a"
    property color colRed: "#FEFF01"
    property int memUsage: 0

    property string activeWindow: "Window"
    property string currentLayout: "Tile"
    property string currentTime: Qt.formatDateTime(new Date(), "HH:mm")

    property string fontFamily: "CaskaydiaCove Nerd Font Mono"
    property int fontSize: 14

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

                memUsage = Math.round(100 * used / total);
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
                    activeWindow = data.trim();
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
            root.currentTime = Qt.formatDateTime(new Date(), "HH:mm");
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            property int activeTag: 1

            screen: modelData

            color: "transparent"
            mask: null

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30

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
                                if (mon.monitor === screen.name) {
                                    let active = mon.tags.find(t => t.is_active);

                                    if (active) {
                                        activeTag = active.index;
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

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 10

                Rectangle {
                    id: workspaces

                    implicitWidth: 200
                    implicitHeight: 24

                    color: root.colBg
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

                                property bool isActive: activeTag === index + 1

                                Text {
                                    anchors.centerIn: parent

                                    text: index + 1

                                    font.pixelSize: 12

                                    color: parent.isActive ? root.colRed : root.colMuted
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

                    color: root.colBg
                    radius: 12

                    Text {
                        anchors.centerIn: parent

                        text: root.currentTime

                        color: root.colRed

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

                        color: root.colBg

                        radius: 12

                        Text {
                            anchors.centerIn: parent

                            text: "RAM: " + root.memUsage + "%"

                            color: root.colRed

                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
