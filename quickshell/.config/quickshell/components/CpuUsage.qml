import QtQuick
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth: size
    implicitHeight: size

    property real size: 24
    property real lineWidth: 3
    property real cpuPercent: 0
    property var prevValues: null

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
            var endAngle = startAngle + (root.cpuPercent / 100) * 2 * Math.PI

            // 배경 원
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, 2 * Math.PI)
            ctx.strokeStyle = Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
            ctx.lineWidth = root.lineWidth
            ctx.stroke()

            // 진행 원호
            ctx.beginPath()
            ctx.arc(cx, cy, r, startAngle, endAngle)
            ctx.strokeStyle = root.cpuPercent > 80
                ? String(Theme.urgentColor)
                : String(Theme.accentColor)
            ctx.lineWidth = root.lineWidth
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }

    // 중앙 아이콘 (nerd font: cpu)
    Text {
        anchors.centerIn: parent
        text: ""
        color: Theme.fgColor
        font.pixelSize: 10
        font.family: "JetBrainsMono Nerd Font"

        Behavior on color { ColorAnimation { duration: 300 } }
    }

    // cpuPercent 변경 시 다시 그리기
    onCpuPercentChanged: canvas.requestPaint()
    Connections {
        target: Theme
        function onAccentColorChanged() { canvas.requestPaint() }
        function onDimColorChanged() { canvas.requestPaint() }
        function onUrgentColorChanged() { canvas.requestPaint() }
    }

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                if (lines.length === 0) return
                var parts = lines[0].trim().split(/\s+/)
                if (parts[0] !== "cpu") return
                var values = parts.slice(1).map(Number)
                if (root.prevValues) {
                    var prevIdle = root.prevValues[3] + (root.prevValues[4] || 0)
                    var currIdle = values[3] + (values[4] || 0)
                    var prevTotal = root.prevValues.reduce(function(a, b) { return a + b }, 0)
                    var currTotal = values.reduce(function(a, b) { return a + b }, 0)
                    var totalDelta = currTotal - prevTotal
                    var idleDelta = currIdle - prevIdle
                    if (totalDelta > 0) {
                        root.cpuPercent = (1 - idleDelta / totalDelta) * 100
                    }
                }
                root.prevValues = values
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: cpuProc.running = true
    }
}
