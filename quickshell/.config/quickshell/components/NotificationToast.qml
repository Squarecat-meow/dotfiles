import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: root

    property string appName: ""
    property string summary: ""
    property string body: ""
    property string iconName: ""
    property bool showing: false
    property bool alive: false

    signal dismissed()

    implicitWidth: 360
    implicitHeight: content.implicitHeight + 24
    radius: 12
    color: Qt.rgba(0, 0, 0, 0.75)

    opacity: showing ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            id: fadeAnim
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    // fade-out 끝나면 model에서 제거 (alive 체크로 초기 상태 무시)
    onOpacityChanged: {
        if (opacity === 0 && alive && !showing) root.dismissed()
    }

    Timer {
        id: dismissTimer
        interval: 5000
        running: root.showing
        onTriggered: root.showing = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.showing = false
    }

    RowLayout {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        spacing: 10

        // 앱 아이콘
        Image {
            id: icon
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            sourceSize.width: 32
            sourceSize.height: 32
            visible: status === Image.Ready
            source: {
                if (!root.iconName) return ""
                // 절대 경로면 그대로 사용
                if (root.iconName.startsWith("/")) return root.iconName
                // 아이콘 테마 이름이면 icon provider 사용
                return "image://icon/" + root.iconName
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: root.appName
                color: Theme.dimColor
                font.family: Theme.fontFamily
                font.pixelSize: 11
                font.weight: Font.Medium
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: root.summary
                color: Theme.fgColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.weight: Font.Bold
                elide: Text.ElideRight
                visible: text !== ""
            }

            Text {
                Layout.fillWidth: true
                text: root.body
                color: Theme.fgColor
                font.family: Theme.fontFamily
                font.pixelSize: 12
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
                visible: text !== ""
            }
        }
    }

    Component.onCompleted: { alive = true; showing = true }
}
