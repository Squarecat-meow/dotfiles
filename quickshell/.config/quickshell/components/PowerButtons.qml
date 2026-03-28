import QtQuick
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth: 20
    implicitHeight: col.implicitHeight

    Column {
        id: col
        width: 8
        spacing: 6

        Repeater {
            model: [
                { label: "", cmd: ["swaylock"] },
                { label: "", cmd: ["systemctl", "suspend"] },
                { label: "󰍃", cmd: ["niri", "msg", "action", "quit"] },
                { label: "⏻", cmd: ["systemctl", "poweroff"] }
            ]

            Rectangle {
                required property var modelData
                required property int index

                width: 34
                height: 34
                radius: 8
                color: btnMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"

                Behavior on color { ColorAnimation { duration: 150 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        text: modelData.label
                        color: modelData.label === "Power Off" ? Theme.urgentColor : Theme.fgColor
                        font.pixelSize: Theme.fontSize + 4
                        font.family: Theme.fontFamily
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }

                MouseArea {
                    id: btnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        ExpandState.close()
                        actionProc.command = modelData.cmd
                        actionProc.startDetached()
                    }
                }
            }
        }
    }

    Process {
        id: actionProc
    }
}
