pragma Singleton

import QtQuick

QtObject {
    property bool expanded: false
    // 드롭다운 확장 시 Dock/프레임이 밀려나는 오프셋
    property real offset: expanded ? expandedHeight : 0
    property real expandedHeight: 0

    Behavior on offset {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    function toggle() { expanded = !expanded }
    function close() { expanded = false }
}
