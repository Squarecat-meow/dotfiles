import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

RowLayout {
    id: root
    spacing: 6
    visible: player !== null

    property var player: {
        var players = Mpris.players
        for (var i = 0; i < players.values.length; i++) {
            var p = players.values[i]
            if (p.playbackState === MprisPlaybackState.Playing) return p
        }
        return players.values.length > 0 ? players.values[0] : null
    }

    Text {
        text: "♪"
        color: Theme.accentAlt
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: {
            if (!root.player) return ""
            var artist = root.player.trackArtist || ""
            var title = root.player.trackTitle || ""
            if (artist && title) return artist + " - " + title
            return title || artist || ""
        }
        color: Theme.fgColor
        font.pixelSize: Theme.fontSize - 1
        font.family: Theme.fontFamily
        elide: Text.ElideRight
        Layout.maximumWidth: 300

        Behavior on color { ColorAnimation { duration: 300 } }
    }
}
