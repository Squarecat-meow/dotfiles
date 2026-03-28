pragma Singleton

import QtQuick

QtObject {
    property bool expanded: false
    function toggle() { expanded = !expanded }
    function close() { expanded = false }
}
