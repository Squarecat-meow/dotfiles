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
            exclusiveZone: 36
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
