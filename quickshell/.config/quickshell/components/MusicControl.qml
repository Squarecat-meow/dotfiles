import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

Item {
    id: root
    implicitWidth: 180
    implicitHeight: col.implicitHeight

    property var player: {
        var players = Mpris.players
        for (var i = 0; i < players.values.length; i++) {
            var p = players.values[i]
            if (p.playbackState === MprisPlaybackState.Playing) return p
        }
        return players.values.length > 0 ? players.values[0] : null
    }

    Column {
        id: col
        width: parent.width
        spacing: 8

        // Album art
        Rectangle {
            width: parent.width
            height: width
            radius: 12
            color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.2)
            clip: true

            Image {
                anchors.fill: parent
                source: root.player && root.player.trackArtUrl ? root.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                text: "\u266B"
                color: Theme.dimColor
                font.pixelSize: 40
                visible: !root.player || !root.player.trackArtUrl || artImg.status !== Image.Ready

                property var artImg: parent.children[0]
            }
        }

        // Title
        Text {
            width: parent.width
            text: root.player ? (root.player.trackTitle || "No Title") : "No Player"
            color: Theme.fgColor
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            font.bold: true
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter

            Behavior on color { ColorAnimation { duration: 300 } }
        }

        // Artist
        Text {
            width: parent.width
            text: root.player ? (root.player.trackArtist || "") : ""
            color: Theme.dimColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.fontFamily
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            visible: text.length > 0

            Behavior on color { ColorAnimation { duration: 300 } }
        }

        // Progress bar
        Item {
            width: parent.width
            height: 4
            visible: root.player && root.player.length > 0

            Rectangle {
                anchors.fill: parent
                radius: 2
                color: Qt.rgba(Theme.dimColor.r, Theme.dimColor.g, Theme.dimColor.b, 0.3)
            }

            Rectangle {
                width: root.player && root.player.length > 0
                    ? parent.width * (root.player.position / root.player.length)
                    : 0
                height: parent.height
                radius: 2
                color: Theme.accentColor

                Behavior on width { NumberAnimation { duration: 500 } }
            }
        }

        // Controls
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Text {
                text: "󰒮"
                color: controlPrev.containsMouse ? Theme.accentColor : Theme.fgColor
                font.pixelSize: 18
                font.family: Theme.fontFamily

                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: controlPrev
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { if (root.player) root.player.previous() }
                }
            }

            Text {
                text: root.player && root.player.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"
                color: controlPlay.containsMouse ? Theme.accentColor : Theme.fgColor
                font.pixelSize: 20
                font.family: Theme.fontFamily

                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: controlPlay
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { if (root.player) root.player.togglePlaying() }
                }
            }

            Text {
                text: "󰒭"
                color: controlNext.containsMouse ? Theme.accentColor : Theme.fgColor
                font.pixelSize: 18
                font.family: Theme.fontFamily

                Behavior on color { ColorAnimation { duration: 150 } }

                MouseArea {
                    id: controlNext
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { if (root.player) root.player.next() }
                }
            }
        }
    }
}
