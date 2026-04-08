import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import ".."

Rectangle {
    id: root
    height: 36
    radius: Theme.radiusSmall
    color: mouseArea.containsMouse
        ? Qt.rgba(Theme.fgColor.r, Theme.fgColor.g, Theme.fgColor.b, 0.08)
        : "transparent"

    property BluetoothDevice device: null

    Behavior on color { ColorAnimation { duration: 100 } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        // 장치 아이콘
        Image {
            id: deviceIcon
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
            sourceSize.width: 32
            sourceSize.height: 32
            property string iconName: root.device ? (root.device.icon || "bluetooth") : ""
            source: iconName !== "" ? "file:///usr/share/icons/Arc/devices/32/" + iconName + ".png" : ""
            onStatusChanged: {
                if (status === Image.Error && iconName !== "") {
                    source = "file:///usr/share/icons/Adwaita/scalable/devices/" + iconName + ".svg"
                }
            }
            Layout.alignment: Qt.AlignVCenter
        }

        // 장치 이름 + 상태
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                text: root.device ? (root.device.name || root.device.address) : ""
                color: Theme.fgColor
                font.pixelSize: Theme.fontSize - 1
                font.family: Theme.fontFamily
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                visible: root.device && root.device.connected && root.device.batteryAvailable
                text: root.device && root.device.batteryAvailable
                    ? Math.round(root.device.battery) + "%"
                    : ""
                color: Theme.dimColor
                font.pixelSize: Theme.fontSize - 3
                font.family: Theme.fontFamily
            }
        }

        // 상태 표시
        Text {
            visible: root.device && root.device.pairing
            text: "Pairing..."
            color: Theme.yellowColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
        }

        // 연결 상태 dot
        Rectangle {
            visible: root.device && root.device.connected
            width: 6; height: 6; radius: 3
            color: Theme.greenColor
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (!root.device) return

            if (mouse.button === Qt.RightButton) {
                // 우클릭: forget (페어링 해제)
                if (root.device.paired) root.device.forget()
                return
            }

            // 좌클릭: 연결/해제/페어링
            if (root.device.connected) {
                root.device.disconnect()
            } else if (root.device.paired) {
                root.device.connect()
            } else {
                root.device.pair()
            }
        }
    }

    // 툴팁
    Rectangle {
        id: tooltip
        visible: mouseArea.containsMouse
        anchors.bottom: parent.top
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        width: tipText.implicitWidth + 12
        height: tipText.implicitHeight + 6
        radius: 4
        color: Theme.bgSolid
        border.width: Theme.borderWidth
        border.color: Theme.borderColor

        Text {
            id: tipText
            anchors.centerIn: parent
            font.pixelSize: Theme.fontSize - 3
            font.family: Theme.fontFamily
            color: Theme.dimColor
            text: {
                if (!root.device) return ""
                if (root.device.connected) return "Click to disconnect, right-click to forget"
                if (root.device.paired) return "Click to connect, right-click to forget"
                return "Click to pair"
            }
        }
    }
}
