import QtQuick
import ".."

Rectangle {
    width: 1
    height: 16
    color: Theme.dimColor

    Behavior on color { ColorAnimation { duration: 300 } }
}
