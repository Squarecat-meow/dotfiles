pragma Singleton

import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property var workspaces: []
    property var windows: []
    property int focusedWorkspaceId: -1

    property Process queryProc: Process {
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    var ws = JSON.parse(data)
                    root.workspaces = ws
                    for (var i = 0; i < ws.length; i++) {
                        if (ws[i].is_focused) {
                            root.focusedWorkspaceId = ws[i].id
                            break
                        }
                    }
                } catch (e) {}
            }
        }
    }

    property Process windowProc: Process {
        command: ["niri", "msg", "-j", "windows"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    root.windows = JSON.parse(data)
                } catch (e) {}
            }
        }
    }

    property Timer pollTimer: Timer {
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            queryProc.running = true
            windowProc.running = true
        }
    }

    function focusWorkspace(idx) {
        var proc = actionProc.createObject(root, {
            command: ["niri", "msg", "action", "focus-workspace", String(idx)]
        })
        proc.running = true
    }

    function focusWindow(windowId) {
        var proc = actionProc.createObject(root, {
            command: ["niri", "msg", "action", "focus-window", "--id", String(windowId)]
        })
        proc.running = true
    }

    property Component actionProc: Component {
        Process {
            onExited: destroy()
        }
    }

    function workspacesForOutput(output) {
        return workspaces.filter(function(ws) { return ws.output === output })
    }

    function windowsByAppId(appId) {
        return windows.filter(function(w) { return w.app_id === appId })
    }
}
