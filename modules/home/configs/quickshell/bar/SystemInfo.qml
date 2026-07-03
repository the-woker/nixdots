pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property string networkInfo: "Disconnected"
    property string networkType: "disconnected"
    property int batteryLevelRaw: 0
    property string temperature: "0°C"

    // CPU Usage
    Process {
        id: cpuProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuUsage = text.trim();
            }
        }
    }

    // Memory Usage
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.1f%%\", ($3/$2) * 100.0}'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.memoryUsage = text.trim();
            }
        }
    }

    // Network Info (ethernet takes priority over wifi)
    Process {
        id: netProc
        command: ["sh", "-c", "eth=$(nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected'); if [ -n \"$eth\" ]; then echo 'ethernet:Ethernet'; else wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); if [ -n \"$wifi\" ]; then echo \"wifi:$wifi\"; else echo 'disconnected:'; fi; fi"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const result = text.trim();
                const colonIdx = result.indexOf(':');
                const type = result.substring(0, colonIdx);
                const info = result.substring(colonIdx + 1);
                root.networkType = type;
                root.networkInfo = info || "Disconnected";
            }
        }
    }

    // Temperature
    Process {
        id: tempProc
        command: ["sh", "-c", "sensors 2>/dev/null | awk '/Package id 0|Tctl/ { match($0, /[0-9]+\.[0-9]+/); if (RSTART) print substr($0, RSTART, RLENGTH); exit }'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.temperature = text.trim() || "N/A";
            }
        }
    }

    // Update timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            netProc.running = true;
            batteryProc.running = true;
            tempProc.running = true;
        }
    }
}
