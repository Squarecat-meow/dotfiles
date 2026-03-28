import QtQuick
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth: size
    implicitHeight: size

    property real size: 24
    property real lineWidth: 3
    property real ramPercent: 0

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2
            var cy = height / 2
            var r = (Math.min(width, height) - root.lineWidth) / 2
            var startAngle = -Math.PI / 2
            var endAngle = startAngle + (root.ramPercent / 100) * 2 * Math.PI

            // 배경 원
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, 2 * Math.PI)
            ctx.strokeStyle = Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
            ctx.lineWidth = root.lineWidth
            ctx.stroke()

            // 진행 원호
            ctx.beginPath()
            ctx.arc(cx, cy, r, startAngle, endAngle)
            ctx.strokeStyle = root.ramPercent > 80
                ? String(Theme.urgentColor)
                : String(Theme.accentAlt)
            ctx.lineWidth = root.lineWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    // 중앙 아이콘 (nerd font: memory)
    Text {
        anchors.centerIn: parent
        text: ""
        color: Theme.fgColor
        font.pixelSize: 10
        font.family: "JetBrainsMono Nerd Font"

        Behavior on color { ColorAnimation { duration: 300 } }
    }

    onRamPercentChanged: canvas.requestPaint()
    Connections {
        target: Theme
        function onAccentAltChanged() { canvas.requestPaint() }
        function onDimColorChanged() { canvas.requestPaint() }
        function onUrgentColorChanged() { canvas.requestPaint() }
    }

    Process {
        id: ramProc
        command: ["cat", "/proc/meminfo"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                var memTotal = 0
                var memAvailable = 0
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    if (line.indexOf("MemTotal:") === 0) {
                        memTotal = parseInt(line.match(/\d+/)[0])
                    } else if (line.indexOf("MemAvailable:") === 0) {
                        memAvailable = parseInt(line.match(/\d+/)[0])
                    }
                    if (memTotal > 0 && memAvailable > 0) break
                }
                if (memTotal > 0) {
                    root.ramPercent = ((memTotal - memAvailable) / memTotal) * 100
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ramProc.running = true
    }
}
