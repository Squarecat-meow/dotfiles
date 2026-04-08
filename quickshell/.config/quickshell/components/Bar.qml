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

    // ExpandState에 확장 높이 전달 (Dock/프레임 오프셋용) — 항상 최신 유지
    Binding {
        target: ExpandState
        property: "expandedHeight"
        value: root.dashHeight
    }

    // L자 프레임 상단 파트
    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        // offset 하나로 높이 제어 — Dock/프레임과 완전 동기화
        height: Theme.barHeight + ExpandState.offset
        clip: true
        color: Theme.bgColor

        // 하단 테두리: 코너 라운딩 사이 직선 부분
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.dockWidth + Theme.radius
            anchors.rightMargin: Theme.frameWidth + Theme.radius
            height: Theme.borderWidth
            color: Theme.borderColor
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
            height: root.dashHeight
            clip: true

            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                height: 1
                color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
                opacity: ExpandState.offset > 0 ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Dashboard {
                id: dashboard
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: ExpandState.offset > 0 ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
