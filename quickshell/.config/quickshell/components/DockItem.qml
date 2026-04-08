import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import ".."
import "../services" as Services

Item {
    id: root
    width: Theme.dockWidth - Theme.dockPadding * 2
    height: width

    property string appId: ""
    property string iconName: ""
    property string command: ""

    // 이 앱의 창 목록
    property var appWindows: Services.NiriIpc.windowsByAppId(appId)
    property bool isRunning: appWindows.length > 0
    property bool isFocused: {
        for (var i = 0; i < appWindows.length; i++) {
            if (appWindows[i].is_focused) return true
        }
        return false
    }

    Connections {
        target: Services.NiriIpc
        function onWindowsChanged() {
            appWindows = Services.NiriIpc.windowsByAppId(root.appId)
        }
    }

    // Hover 배경
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusSmall
        color: mouseArea.containsMouse
            ? Qt.rgba(Theme.fgColor.r, Theme.fgColor.g, Theme.fgColor.b, 0.1)
            : "transparent"

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // 아이콘
    IconImage {
        anchors.centerIn: parent
        width: Theme.dockIconSize
        height: Theme.dockIconSize
        source: Quickshell.iconPath(root.iconName, "application-x-executable")

        // 포커스 시 살짝 밝게
        opacity: root.isFocused ? 1.0 : mouseArea.containsMouse ? 0.9 : 0.7
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    // 실행 중 표시 dot (좌측)
    Rectangle {
        visible: root.isRunning
        width: root.isFocused ? 8 : 4
        height: width
        radius: width / 2
        color: root.isFocused ? Theme.accentColor : Theme.dimColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: -2

        Behavior on width { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // 툴팁
    Rectangle {
        id: tooltip
        visible: mouseArea.containsMouse
        anchors.left: parent.right
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: tooltipText.implicitWidth + 16
        height: tooltipText.implicitHeight + 8
        radius: Theme.radiusSmall
        color: Theme.bgSolid
        border.width: Theme.borderWidth
        border.color: Theme.borderColor

        Text {
            id: tooltipText
            anchors.centerIn: parent
            text: root.appId
            color: Theme.fgColor
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.isRunning) {
                // 첫 번째 창으로 포커스
                Services.NiriIpc.focusWindow(root.appWindows[0].id)
            } else if (root.command) {
                launchProc.running = true
            }
        }
    }

    Process {
        id: launchProc
        command: ["sh", "-c", root.command]
    }
}
