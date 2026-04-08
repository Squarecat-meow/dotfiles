import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root
    implicitWidth: dashRow.implicitWidth + 32
    implicitHeight: dashRow.implicitHeight + 16

    RowLayout {
        id: dashRow
        anchors.centerIn: parent
        spacing: 16

        MusicControl {
            Layout.alignment: Qt.AlignTop
        }

        // Separator
        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
        }

        // Calendar + Weather stacked vertically
        Column {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 240
            spacing: 8

            CalendarPopup {
                width: parent.width
            }

            // Thin horizontal divider
            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
            }

            WeatherForecast {
                width: parent.width
            }
        }

        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
        }

        QuickSettings {
            Layout.alignment: Qt.AlignTop
        }

        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
        }

        BluetoothPanel {
            Layout.alignment: Qt.AlignTop
        }

        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
        }

        PowerButtons {
            Layout.alignment: Qt.AlignTop
        }
    }
}
