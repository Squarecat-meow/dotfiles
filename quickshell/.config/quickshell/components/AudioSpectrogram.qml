import QtQuick
import QtQuick.Layouts
import ".."
import "../services" as Services

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: 20
    Layout.alignment: Qt.AlignVCenter

    property var bars: Services.CavaService.bars

    Row {
        id: row
        spacing: 2
        anchors.bottom: parent.bottom

        Repeater {
            model: bars.length

            Rectangle {
                required property int index

                anchors.bottom: parent.bottom
                width: 3
                height: Math.max(2, (bars[index] / 100) * 20)
                radius: 1.5
                color: Theme.accentColor
                opacity: 0.8

                Behavior on height { NumberAnimation { duration: 50 } }
                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }
    }
}
