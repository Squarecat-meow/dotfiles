import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import ".."

Item {
    id: root
    implicitWidth: 280
    implicitHeight: contentCol.implicitHeight

    property var adapter: Bluetooth.defaultAdapter

    ColumnLayout {
        id: contentCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 8

        // 헤더: 블루투스 on/off + 스캔
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Bluetooth"
                color: Theme.fgColor
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: true
                Layout.fillWidth: true
            }

            // 스캔 버튼
            Rectangle {
                width: scanText.implicitWidth + 16
                height: 24
                radius: Theme.radiusSmall
                color: root.adapter && root.adapter.discovering
                    ? Theme.accentColor
                    : Qt.rgba(Theme.fgColor.r, Theme.fgColor.g, Theme.fgColor.b, 0.1)

                Text {
                    id: scanText
                    anchors.centerIn: parent
                    text: root.adapter && root.adapter.discovering ? "Scanning..." : "Scan"
                    color: root.adapter && root.adapter.discovering ? Theme.bgSolid : Theme.fgColor
                    font.pixelSize: Theme.fontSize - 2
                    font.family: Theme.fontFamily
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.adapter)
                            root.adapter.discovering = !root.adapter.discovering
                    }
                }
            }

            // on/off 토글
            Rectangle {
                width: 36
                height: 20
                radius: 10
                color: root.adapter && root.adapter.enabled
                    ? Theme.accentColor
                    : Qt.rgba(Theme.fgColor.r, Theme.fgColor.g, Theme.fgColor.b, 0.2)

                Behavior on color { ColorAnimation { duration: 150 } }

                Rectangle {
                    width: 16; height: 16; radius: 8
                    anchors.verticalCenter: parent.verticalCenter
                    x: root.adapter && root.adapter.enabled ? parent.width - width - 2 : 2
                    color: Theme.fgColor

                    Behavior on x { NumberAnimation { duration: 150 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.adapter)
                            root.adapter.enabled = !root.adapter.enabled
                    }
                }
            }
        }

        // 구분선
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.borderColor
        }

        // 연결된 장치
        Text {
            text: "Connected"
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
            visible: connectedRepeater.count > 0
        }

        Repeater {
            id: connectedRepeater
            model: {
                if (!Bluetooth.devices) return []
                var result = []
                for (var i = 0; i < Bluetooth.devices.values.length; i++) {
                    var d = Bluetooth.devices.values[i]
                    if (d.connected) result.push(d)
                }
                return result
            }

            delegate: BluetoothDeviceItem {
                required property var modelData
                device: modelData
                Layout.fillWidth: true
            }
        }

        // 페어링된 (연결 안 된) 장치
        Text {
            text: "Paired"
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
            visible: pairedRepeater.count > 0
        }

        Repeater {
            id: pairedRepeater
            model: {
                if (!Bluetooth.devices) return []
                var result = []
                for (var i = 0; i < Bluetooth.devices.values.length; i++) {
                    var d = Bluetooth.devices.values[i]
                    if (d.paired && !d.connected) result.push(d)
                }
                return result
            }

            delegate: BluetoothDeviceItem {
                required property var modelData
                device: modelData
                Layout.fillWidth: true
            }
        }

        // 스캔된 새 장치
        Text {
            text: "Available"
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
            visible: root.adapter && root.adapter.discovering && availableRepeater.count > 0
        }

        Repeater {
            id: availableRepeater
            model: {
                if (!Bluetooth.devices || !root.adapter || !root.adapter.discovering) return []
                var result = []
                for (var i = 0; i < Bluetooth.devices.values.length; i++) {
                    var d = Bluetooth.devices.values[i]
                    if (!d.paired && !d.connected && d.name) result.push(d)
                }
                return result
            }

            delegate: BluetoothDeviceItem {
                required property var modelData
                device: modelData
                Layout.fillWidth: true
            }
        }

        // 장치 없음 메시지
        Text {
            visible: connectedRepeater.count === 0 && pairedRepeater.count === 0 && availableRepeater.count === 0
            text: root.adapter && root.adapter.enabled
                ? (root.adapter.discovering ? "Searching..." : "No devices")
                : "Bluetooth off"
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.topMargin: 4
            Layout.bottomMargin: 4
        }
    }
}
