pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property var colors: ({})
    property string lastJson: ""

    // Gruvbox Dark fallback
    readonly property color bgColor: {
        var c = Qt.color(colors.background || "#282828")
        return Qt.rgba(c.r, c.g, c.b, 0.85)
    }
    readonly property color bgSolid: Qt.color(colors.background || "#282828")
    readonly property color fgColor: Qt.color(colors.foreground || "#ebdbb2")
    readonly property color accentColor: Qt.color(colors.color4 || "#458588")
    readonly property color accentAlt: Qt.color(colors.color5 || "#b16286")
    readonly property color dimColor: Qt.color(colors.color8 || "#928374")
    readonly property color urgentColor: Qt.color(colors.color1 || "#cc241d")
    readonly property color greenColor: Qt.color(colors.color2 || "#98971a")
    readonly property color yellowColor: Qt.color(colors.color3 || "#d79921")
    readonly property color cyanColor: Qt.color(colors.color6 || "#689d6a")

    readonly property int barHeight: 36
    readonly property int fontSize: 13
    readonly property string fontFamily: "Pretendard"
    readonly property int spacing: 12
    readonly property int modulePadding: 8

    property Process colorProc: Process {
        command: ["cat", Quickshell.env("HOME") + "/.cache/wallust/quickshell_colors.json"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                if (data && data !== root.lastJson) {
                    root.lastJson = data
                    try {
                        root.colors = JSON.parse(data)
                    } catch (e) {}
                }
            }
        }
    }

    property Timer pollTimer: Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: colorProc.running = true
    }
}
