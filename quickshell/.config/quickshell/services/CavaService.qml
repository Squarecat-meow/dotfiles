pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property var bars: [0,0,0,0,0,0,0,0,0,0,0,0]
    property bool running: true

    property Process cavaProc: Process {
        id: proc
        command: ["cava", "-p", Qt.resolvedUrl("../assets/cava-config").toString().replace("file://", "")]
        running: root.running
        stdout: SplitParser {
            onRead: data => {
                var values = data.split(";").filter(function(s) { return s.length > 0 }).map(Number)
                if (values.length > 0) {
                    root.bars = values
                }
            }
        }
        onExited: (code, status) => {
            restartTimer.start()
        }
    }

    property Timer restartTimer: Timer {
        interval: 3000
        onTriggered: {
            if (root.running) proc.running = true
        }
    }
}
