import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property string outputName: ""
    property alias bgItem: bg
    property real dashHeight: dashboard.implicitHeight + 24
    // 항상 최대 높이 유지 — Wayland compositor 지터 방지
    property real expandedH: Theme.barHeight + dashHeight

    implicitHeight: expandedH

    // 검정 -> 투명 그라데이션 배경
    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: ExpandState.expanded ? root.expandedH : Theme.barHeight
        clip: true

        Behavior on height {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.85) }
            GradientStop { position: 1.0; color: "transparent" }
        }

        // Top bar - 3 섹션 레이아웃
        Item {
            id: topBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Theme.barHeight

            // 왼쪽: ArchIcon, Workspace, NowPlaying, Cava
            RowLayout {
                id: leftSection
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacing

                ArchIcon {}

                WorkspaceIndicator { outputName: root.outputName }

                Separator { Layout.alignment: Qt.AlignVCenter }

                AudioSpectrogram {}

                NowPlaying {}
            }

            // 가운데: 시계, 날씨
            RowLayout {
                id: centerSection
                anchors.centerIn: parent
                spacing: Theme.spacing

                Clock {}

                Separator { Layout.alignment: Qt.AlignVCenter }

                Weather {}
            }

            // 오른쪽: CPU, RAM, Network, Volume, Power
            RowLayout {
                id: rightSection
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacing

                CpuUsage {}

                RamUsage {}

                NetworkSpeed {}

                Separator { Layout.alignment: Qt.AlignVCenter }

                SysTray {}

                Separator { Layout.alignment: Qt.AlignVCenter }

                VolumeIcon {}

                Separator { Layout.alignment: Qt.AlignVCenter }

                PowerMenu {}
            }
        }

        // Dashboard area
        Item {
            id: expandedArea
            anchors.top: topBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: bg.height - Theme.barHeight
            clip: true

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                height: 1
                color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
                opacity: ExpandState.expanded ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Dashboard {
                id: dashboard
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: ExpandState.expanded ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: ExpandState.expanded ? 200 : 150
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
