import QtQuick
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth: 48
    implicitHeight: txText.implicitHeight + rxText.implicitHeight + 2

    property string targetInterface: "enp2s0"
    property real txSpeed: 0
    property real rxSpeed: 0
    property real prevTx: -1
    property real prevRx: -1
    property real prevTime: 0

    function formatSpeed(bytesPerSec) {
        if (bytesPerSec >= 1048576) {
            return (bytesPerSec / 1048576).toFixed(1) + " MB/s"
        } else if (bytesPerSec >= 1024) {
            return Math.round(bytesPerSec / 1024) + " KB/s"
        }
        return Math.round(bytesPerSec) + " B/s"
    }

    TextMetrics {
        id: txMetrics
        font: txText.font
        text: "↑ 000.0 M/s"
    }
    TextMetrics {
        id: rxMetrics
        font: rxText.font
        text: "↓ 000.0 M/s"
    }

    Text {
        id: txText
        anchors.top: parent.top
        anchors.left: parent.left
        text: "↑ " + formatSpeed(root.txSpeed)
        color: Theme.fgColor
        font.pixelSize: Theme.fontSize - 3
        font.family: Theme.fontFamily
        horizontalAlignment: Text.AlignLeft

        Behavior on color { ColorAnimation { duration: 300 } }
    }

    Text {
        id: rxText
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        text: "↓ " + formatSpeed(root.rxSpeed)
        color: Theme.fgColor
        font.pixelSize: Theme.fontSize - 3
        font.family: Theme.fontFamily
        horizontalAlignment: Text.AlignLeft

        Behavior on color { ColorAnimation { duration: 300 } }
    }

    Process {
        id: netProc
        command: ["cat", "/proc/net/dev"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var now = Date.now() / 1000
                var lines = data.split("\n")
                for (var i = 2; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.indexOf(root.targetInterface) !== 0) continue

                    var parts = line.split(/\s+/)
                    var rxBytes = parseFloat(parts[1])
                    var txBytes = parseFloat(parts[9])

                    if (root.prevRx >= 0 && root.prevTime > 0) {
                        var dt = now - root.prevTime
                        if (dt > 0) {
                            root.rxSpeed = (rxBytes - root.prevRx) / dt
                            root.txSpeed = (txBytes - root.prevTx) / dt
                        }
                    }
                    root.prevRx = rxBytes
                    root.prevTx = txBytes
                    root.prevTime = now
                    break
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.running = true
    }
}
