import QtQuick
import ".."

Item {
    width: 20
    height: 20

    Text {
      id: archicon
      text: ""
      color: Theme.accentColor
      font.pixelSize: Theme.fontSize + 4
      font.family: Theme.fontFamily
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: ExpandState.toggle()
    }
}
