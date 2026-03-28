import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    implicitWidth: clockText.implicitWidth
    implicitHeight: clockText.implicitHeight

    Text {
        id: clockText

        property string timeStr: Qt.formatDateTime(new Date(), "HH:mm")

        text: timeStr
        color: Theme.fgColor
        font.pixelSize: Theme.fontSize + 4
        font.family: Theme.fontFamily
        font.bold: true

        Behavior on color { ColorAnimation { duration: 300 } }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.timeStr = Qt.formatDateTime(new Date(), "HH:mm")
        }

    }
}
