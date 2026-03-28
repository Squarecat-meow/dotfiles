import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: powerBtn.implicitWidth
    implicitHeight: powerBtn.implicitHeight

    Text {
        id: powerBtn
        text: "\u23FB"
        color: hovered ? Theme.urgentColor : Theme.fgColor
        font.pixelSize: Theme.fontSize + 1
        property bool hovered: false

        Behavior on color { ColorAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: powerBtn.hovered = true
            onExited: powerBtn.hovered = false
            onClicked: ExpandState.toggle()
        }
    }
}
