import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import "components" as Components

ShellRoot {
    id: shell

    ListModel { id: notifModel }

    NotificationServer {
        id: notifServer
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notification => {
            notifModel.append({
                nAppName: notification.appName || "Notification",
                nSummary: notification.summary || "",
                nBody: notification.body || "",
                nIcon: notification.appIcon || notification.image || ""
            })
        }
    }

    // 상단바
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barWindow
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            exclusiveZone: Theme.barHeight
            color: "transparent"
            implicitHeight: barContent.expandedH

            mask: Region { item: barContent.bgItem }

            Components.Bar {
                id: barContent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                outputName: modelData.name
            }
        }
    }

    // 좌측 Dock — PanelWindow는 고정, 내부 콘텐츠만 offset
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: dockWindow
            property var modelData
            screen: modelData

            anchors {
                left: true
                top: true
                bottom: true
            }
            exclusiveZone: Theme.dockWidth
            color: "transparent"
            implicitWidth: Theme.dockWidth

            mask: Region { item: dockContent.bgItem }

            Components.Dock {
                id: dockContent
                anchors.fill: parent
            }
        }
    }

    // 우측 프레임 — PanelWindow는 고정, 내부 테두리만 offset
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: frameRight
            property var modelData
            screen: modelData

            anchors {
                right: true
                top: true
                bottom: true
            }
            exclusiveZone: Theme.frameWidth
            color: "transparent"
            implicitWidth: Theme.frameWidth

            mask: Region { item: frameRightContent.bgItem }

            Components.FrameEdge {
                id: frameRightContent
                anchors.fill: parent
                edge: "right"
            }
        }
    }

    // 하단 프레임
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: frameBottom
            property var modelData
            screen: modelData

            anchors {
                bottom: true
                left: true
                right: true
            }
            exclusiveZone: Theme.frameWidth
            color: "transparent"
            implicitHeight: Theme.frameWidth

            mask: Region { item: frameBottomContent.bgItem }

            Components.FrameEdge {
                id: frameBottomContent
                anchors.fill: parent
                edge: "bottom"
            }
        }
    }

    // 콘텐츠 영역 코너 라운딩 (4개)
    // 좌상: Bar↔Dock 교차점 — 확장 시 offset만큼 내려감
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData; screen: modelData
            anchors { top: true; left: true }
            margins.top: ExpandState.offset
            exclusiveZone: 0; color: "transparent"
            implicitWidth: Theme.radius; implicitHeight: Theme.radius
            mask: Region { item: cornerTL.bgItem }
            Components.FrameCorner { id: cornerTL; anchors.fill: parent; corner: "topLeft" }
        }
    }
    // 우상: Bar↔우측프레임 교차점 — 확장 시 offset만큼 내려감
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData; screen: modelData
            anchors { top: true; right: true }
            margins.top: ExpandState.offset
            exclusiveZone: 0; color: "transparent"
            implicitWidth: Theme.radius; implicitHeight: Theme.radius
            mask: Region { item: cornerTR.bgItem }
            Components.FrameCorner { id: cornerTR; anchors.fill: parent; corner: "topRight" }
        }
    }
    // 좌하: Dock↔하단프레임 교차점
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData; screen: modelData
            anchors { bottom: true; left: true }
            exclusiveZone: 0; color: "transparent"
            implicitWidth: Theme.radius; implicitHeight: Theme.radius
            mask: Region { item: cornerBL.bgItem }
            Components.FrameCorner { id: cornerBL; anchors.fill: parent; corner: "bottomLeft" }
        }
    }
    // 우하: 우측프레임↔하단프레임 교차점
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData; screen: modelData
            anchors { bottom: true; right: true }
            exclusiveZone: 0; color: "transparent"
            implicitWidth: Theme.radius; implicitHeight: Theme.radius
            mask: Region { item: cornerBR.bgItem }
            Components.FrameCorner { id: cornerBR; anchors.fill: parent; corner: "bottomRight" }
        }
    }

    // Notification toast (오른쪽 위)
    PanelWindow {
        id: notifWindow

        anchors {
            top: true
            right: true
        }
        margins.top: 0
        margins.right: 8
        exclusiveZone: 0
        color: "transparent"
        visible: notifModel.count > 0

        implicitWidth: 360
        implicitHeight: notifColumn.implicitHeight

        mask: Region { item: notifColumn }

        Column {
            id: notifColumn
            anchors.right: parent.right
            width: 360
            spacing: 8

            Repeater {
                model: notifModel

                delegate: Components.NotificationToast {
                    required property int index
                    required property string nAppName
                    required property string nSummary
                    required property string nBody
                    required property string nIcon

                    appName: nAppName
                    summary: nSummary
                    body: nBody
                    iconName: nIcon
                    width: notifColumn.width

                    onDismissed: notifModel.remove(index)
                }
            }
        }
    }
}
