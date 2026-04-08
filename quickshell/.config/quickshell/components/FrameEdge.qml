import QtQuick
import ".."

// 액자 프레임의 우측/하단 얇은 스트립
Item {
    id: root

    property alias bgItem: bg
    // "right" 또는 "bottom"
    property string edge: "right"

    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        // 우측 프레임만 확장 시 위에서 줄어듦
        anchors.topMargin: root.edge === "right" ? ExpandState.offset : 0
        color: Theme.bgColor

        // 우측 프레임: 좌측에 내부 테두리
        Rectangle {
            visible: root.edge === "right"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.radius
            anchors.bottomMargin: Theme.radius
            width: Theme.borderWidth
            color: Theme.borderColor
        }

        // 하단 프레임: 상단에 내부 테두리 (코너 여백 포함)
        Rectangle {
            visible: root.edge === "bottom"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.radius
            anchors.rightMargin: Theme.radius
            height: Theme.borderWidth
            color: Theme.borderColor
        }
    }
}
