import QtQuick
import QtQuick.Layouts
import ".."
import "../services" as Services

RowLayout {
    id: root
    spacing: 8

    property string outputName: ""

    property int wsCount: {
        var all = Services.NiriIpc.workspaces
        var max = 0
        for (var i = 0; i < all.length; i++) {
            if (all[i].output === outputName && all[i].idx > max)
                max = all[i].idx
        }
        return max
    }

    function getWs(idx) {
        var all = Services.NiriIpc.workspaces
        for (var i = 0; i < all.length; i++) {
            if (all[i].output === outputName && all[i].idx === idx)
                return all[i]
        }
        return null
    }

    Repeater {
        model: wsCount

        Item {
            required property int index
            property int wsIdx: index + 1
            property var ws: root.getWs(wsIdx)
            property bool isFocused: ws ? ws.is_focused : false
            property bool isActive: ws ? ws.is_active : false
            property bool wasFocused: false

            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 8
            implicitHeight: 8

            // ping 잔상
            Rectangle {
                id: ping
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: height / 2
                color: Theme.accentColor
                opacity: 0
                visible: opacity > 0

                SequentialAnimation {
                    id: pingAnim
                    NumberAnimation { target: ping; property: "opacity"; from: 0.6; to: 0; duration: 600; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ping; property: "width"; from: 8; to: 8; duration: 0 }
                    NumberAnimation { target: ping; property: "height"; from: 8; to: 8; duration: 0 }
                }

                ParallelAnimation {
                    id: pingStart
                    NumberAnimation { target: ping; property: "width"; from: 8; to: 24; duration: 600; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ping; property: "height"; from: 8; to: 24; duration: 600; easing.type: Easing.OutQuad }
                    NumberAnimation { target: ping; property: "opacity"; from: 0.6; to: 0; duration: 600; easing.type: Easing.OutQuad }
                }
            }

            // 실제 dot
            Rectangle {
                id: dot
                anchors.centerIn: parent
                width: 8
                height: 8
                radius: height / 2
                color: isFocused ? Theme.accentColor : isActive ? Theme.fgColor : Theme.dimColor
                opacity: isFocused ? 1.0 : isActive ? 0.7 : 0.4

                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            onIsFocusedChanged: {
                if (isFocused && !wasFocused) {
                    pingStart.restart()
                }
                wasFocused = isFocused
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Services.NiriIpc.focusWorkspace(wsIdx)
            }
        }
    }
}
