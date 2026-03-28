import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."

Item {
    id: root

    implicitWidth: 42
    implicitHeight: volumeText.implicitHeight

    property PwNode sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker {
        objects: [root.sink]
    }

    Text {
        id: volumeText
        text: {
            if (root.muted || root.volume === 0) return " mute"
            var pct = Math.round(root.volume * 100)
            if (root.volume < 0.33) return "󰖀  " + pct + "%"
            if (root.volume < 0.66) return "󰕾  " + pct + "%"
            return "\uD83D\uDD0A " + pct + "%"
        }
        color: root.muted ? Theme.dimColor : Theme.fgColor
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily

        Behavior on color { ColorAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: pavuProc.startDetached()
        }
    }

    Process {
        id: pavuProc
        command: ["pavucontrol"]
    }
}
