import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import ".."
import "../services" as Services

Item {
    id: root
    implicitWidth: Theme.dockWidth

    property alias bgItem: bg

    // 고정 앱 목록
    readonly property var pinnedApps: [
        { appId: "firefox",  icon: "firefox",           cmd: "firefox" },
        { appId: "kitty",    icon: "kitty",             cmd: "kitty" },
        { appId: "discord",  icon: "discord",           cmd: "discord" },
        { appId: "Element",  icon: "io.element.Element", cmd: "element-desktop" }
    ]

    // 실행 중이지만 고정 앱에 없는 앱 목록
    property var runningApps: []

    function updateRunningApps() {
        var pinnedIds = pinnedApps.map(function(a) { return a.appId.toLowerCase() })
        var seen = {}
        var result = []
        var wins = Services.NiriIpc.windows
        for (var i = 0; i < wins.length; i++) {
            var w = wins[i]
            var aid = w.app_id ? w.app_id.toLowerCase() : ""
            if (aid && !seen[aid] && pinnedIds.indexOf(aid) === -1) {
                seen[aid] = true
                result.push({ appId: w.app_id, icon: aid })
            }
        }
        runningApps = result
    }

    Connections {
        target: Services.NiriIpc
        function onWindowsChanged() { updateRunningApps() }
    }

    Component.onCompleted: updateRunningApps()

    // 배경 — 확장 시 위에서부터 줄어듦 (바가 덮는 영역은 투명)
    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.topMargin: ExpandState.offset
        color: Theme.bgColor

        // 우측 테두리
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.radius
            anchors.bottomMargin: Theme.frameWidth + Theme.radius
            width: Theme.borderWidth
            color: Theme.borderColor
        }
    }

    ColumnLayout {
        id: dockColumn
        anchors.top: bg.top
        anchors.topMargin: Theme.dockPadding
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        width: Theme.dockWidth - Theme.dockPadding * 2

        // 고정 앱
        Repeater {
            model: root.pinnedApps

            DockItem {
                required property var modelData
                appId: modelData.appId
                iconName: modelData.icon
                command: modelData.cmd
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // 구분선
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: Theme.dockIconSize
            height: 1
            color: Theme.borderColor
            visible: runningApps.length > 0
        }

        // 실행 중인 앱 (고정 앱 제외)
        Repeater {
            model: root.runningApps

            DockItem {
                required property var modelData
                appId: modelData.appId
                iconName: modelData.icon
                command: ""
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
