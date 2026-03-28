import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: 6

        Repeater {
            model: WeatherData.forecast

            Rectangle {
                width: 80
                height: 60
                radius: 8
                color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.1)

                Column {
                    anchors.centerIn: parent
                    spacing: 2

                    Text {
                        text: modelData.label
                        color: Theme.dimColor
                        font.pixelSize: Theme.fontSize - 2
                        font.family: Theme.fontFamily
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: modelData.icon
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: modelData.maxTemp + "\u00B0 / " + modelData.minTemp + "\u00B0"
                        color: Theme.fgColor
                        font.pixelSize: Theme.fontSize - 2
                        font.family: Theme.fontFamily
                        anchors.horizontalCenter: parent.horizontalCenter

                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }
            }
        }

        // Loading state
        Text {
            visible: WeatherData.forecast.length === 0
            text: "..."
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
        }
    }
}
