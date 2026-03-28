import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."

Item {
    id: root
    implicitWidth: 40
    implicitHeight: col.implicitHeight

    property PwNode sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false
    property real brightness: -1
    property bool hasBrightness: brightness >= 0

    PwObjectTracker {
        objects: [root.sink]
    }

    Column {
        id: col
        width: parent.width
        spacing: 8

        // Vertical sliders row
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            // Volume vertical slider
            Column {
                spacing: 4

                // Vertical slider track
                Item {
                    width: 30
                    height: 100

                    // Background track
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 4
                        height: parent.height
                        radius: 2
                        color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
                    }

                    // Fill (bottom to top)
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: 4
                        height: parent.height * root.volume
                        radius: 2
                        color: root.muted ? Theme.dimColor : Theme.accentColor

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    // Knob
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: Math.max(0, Math.min(parent.height - height, parent.height * (1 - root.volume) - height / 2))
                        width: 14
                        height: 14
                        radius: 7
                        color: Theme.fgColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: updateVolume(mouseY)
                        onPositionChanged: if (pressed) updateVolume(mouseY)

                        function updateVolume(my) {
                            var v = Math.max(0, Math.min(1, 1 - my / height))
                            if (root.sink && root.sink.audio)
                                root.sink.audio.volume = v
                        }
                    }
                }

                // Volume icon (clickable for mute)
                Text {
                    text: root.muted ? "\uD83D\uDD07" : "\uD83D\uDD0A"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.sink && root.sink.audio)
                                root.sink.audio.muted = !root.sink.audio.muted
                        }
                    }
                }

                // Volume percentage
                Text {
                    text: Math.round(root.volume * 100) + "%"
                    color: root.muted ? Theme.dimColor : Theme.fgColor
                    font.pixelSize: Theme.fontSize - 2
                    font.family: Theme.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter

                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }

            // Brightness vertical slider
            Column {
                spacing: 4
                visible: root.hasBrightness

                // Vertical slider track
                Item {
                    width: 30
                    height: 100

                    // Background track
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 4
                        height: parent.height
                        radius: 2
                        color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
                    }

                    // Fill (bottom to top)
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        width: 4
                        height: parent.height * Math.max(0, root.brightness)
                        radius: 2
                        color: Theme.yellowColor

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    // Knob
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: Math.max(0, Math.min(parent.height - height, parent.height * (1 - root.brightness) - height / 2))
                        width: 14
                        height: 14
                        radius: 7
                        color: Theme.fgColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: updateBrightness(mouseY)
                        onPositionChanged: if (pressed) updateBrightness(mouseY)

                        function updateBrightness(my) {
                            var v = Math.max(0.01, Math.min(1, 1 - my / height))
                            root.brightness = v
                            var pct = Math.round(v * 100)
                            brightnessSetProc.command = ["brightnessctl", "set", pct + "%"]
                            brightnessSetProc.running = true
                        }
                    }
                }

                // Brightness icon
                Text {
                    text: "\uD83D\uDD06"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Brightness percentage
                Text {
                    text: Math.round(root.brightness * 100) + "%"
                    color: Theme.fgColor
                    font.pixelSize: Theme.fontSize - 2
                    font.family: Theme.fontFamily
                    anchors.horizontalCenter: parent.horizontalCenter

                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }
    }

    Process {
        id: brightnessGetProc
        command: ["sh", "-c", "brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%'"]
        stdout: SplitParser {
            onRead: data => {
                var val = parseFloat(data.trim())
                if (!isNaN(val)) root.brightness = val / 100
            }
        }
        onExited: (code, status) => {
            if (code !== 0) root.brightness = -1
        }
    }

    Process {
        id: brightnessSetProc
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: brightnessGetProc.running = true
    }
}
