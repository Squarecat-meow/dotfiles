import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import ".."

RowLayout {
    id: root
    spacing: 4

    // 아이콘 경로 캐시 (한번 resolve하면 재사용)
    property var iconCache: ({})

    function getCachedIcon(name) {
        return iconCache[name] || ""
    }

    function cacheIcon(name, path) {
        var c = Object.assign({}, iconCache)
        c[name] = path
        iconCache = c
    }

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property var modelData

            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter

            visible: modelData.status !== Status.Passive

            property string currentIconName: {
                var raw = modelData.icon || ""
                if (raw.startsWith("image://icon/"))
                    return raw.substring("image://icon/".length)
                return raw
            }

            // resolve 요청 중인 아이콘 이름
            property string pendingName: ""

            onCurrentIconNameChanged: resolve()

            Process {
                id: resolver
                property string resolvingName: ""
                command: ["python3", "-c",
                    "import gi; gi.require_version('Gtk','3.0'); from gi.repository import Gtk; " +
                    "t=Gtk.IconTheme.get_default(); " +
                    "n='" + resolver.resolvingName + "'; " +
                    "i=t.lookup_icon(n,48,0) or t.lookup_icon(n.replace('-symbolic',''),48,0); " +
                    "print(i.get_filename() if i else '')"
                ]
                running: false
                stdout: SplitParser {
                    splitMarker: ""
                    onRead: data => {
                        var p = data.trim()
                        if (p) root.cacheIcon(resolver.resolvingName, p)
                    }
                }
            }

            function resolve() {
                var name = currentIconName
                if (!name) return
                // 이미 캐시에 있으면 프로세스 안 띄움
                if (root.getCachedIcon(name)) return
                // 절대 경로나 내부 provider면 캐시에 바로 넣기
                if (name.startsWith("/") || name.startsWith("image://")) {
                    root.cacheIcon(name, name)
                    return
                }
                resolver.resolvingName = name
                resolver.running = true
            }

            Component.onCompleted: resolve()

            Image {
                anchors.fill: parent
                sourceSize.width: 20
                sourceSize.height: 20
                source: {
                    var name = trayItem.currentIconName
                    if (!name) return ""
                    return root.getCachedIcon(name)
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton || modelData.onlyMenu) {
                        modelData.display(trayItem, mouse.x, mouse.y)
                    } else {
                        modelData.activate()
                    }
                }
            }
        }
    }
}
