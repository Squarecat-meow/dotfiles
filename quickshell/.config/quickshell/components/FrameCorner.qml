import QtQuick
import ".."

// 콘텐츠 영역 모서리 라운딩 오버레이
// 프레임 bgColor 쐐기로 콘텐츠 코너를 둥글게 가림 + 테두리 곡선
// corner: "topLeft" | "topRight" | "bottomLeft" | "bottomRight"
Item {
    id: root
    width: Theme.radius
    height: Theme.radius

    property string corner: "topLeft"
    property alias bgItem: mask

    Item { id: mask; anchors.fill: parent }

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            var r = width
            ctx.clearRect(0, 0, r, r)

            var bg = Theme.bgColor
            ctx.fillStyle = Qt.rgba(bg.r, bg.g, bg.b, bg.a)
            var bc = Theme.borderColor
            ctx.strokeStyle = Qt.rgba(bc.r, bc.g, bc.b, bc.a)
            ctx.lineWidth = Theme.borderWidth

            // 쐐기(wedge) 채우기: 프레임 쪽은 bgColor, 콘텐츠 쪽은 투명
            ctx.beginPath()
            if (root.corner === "topLeft") {
                // 콘텐츠 코너 (0,0), 호 중심 (r,r)
                ctx.moveTo(0, 0)
                ctx.lineTo(r, 0)
                ctx.arc(r, r, r, -Math.PI / 2, Math.PI, true)
                ctx.closePath()
            } else if (root.corner === "topRight") {
                // 콘텐츠 코너 (r,0), 호 중심 (0,r)
                ctx.moveTo(r, 0)
                ctx.lineTo(0, 0)
                ctx.arc(0, r, r, -Math.PI / 2, 0)
                ctx.lineTo(r, 0)
                ctx.closePath()
            } else if (root.corner === "bottomLeft") {
                // 콘텐츠 코너 (0,r), 호 중심 (r,0)
                ctx.moveTo(0, r)
                ctx.lineTo(0, 0)
                ctx.arc(r, 0, r, Math.PI, Math.PI / 2, true)
                ctx.lineTo(0, r)
                ctx.closePath()
            } else if (root.corner === "bottomRight") {
                // 콘텐츠 코너 (r,r), 호 중심 (0,0)
                ctx.moveTo(r, r)
                ctx.lineTo(r, 0)
                ctx.arc(0, 0, r, 0, Math.PI / 2)
                ctx.lineTo(r, r)
                ctx.closePath()
            }
            ctx.fill()

            // 곡선 테두리
            ctx.beginPath()
            if (root.corner === "topLeft") {
                ctx.arc(r, r, r - 0.5, -Math.PI / 2, Math.PI, true)
            } else if (root.corner === "topRight") {
                ctx.arc(0, r, r - 0.5, -Math.PI / 2, 0)
            } else if (root.corner === "bottomLeft") {
                ctx.arc(r, 0, r - 0.5, Math.PI, Math.PI / 2, true)
            } else if (root.corner === "bottomRight") {
                ctx.arc(0, 0, r - 0.5, 0, Math.PI / 2)
            }
            ctx.stroke()
        }

        Connections {
            target: Theme
            function onBgColorChanged() { canvas.requestPaint() }
            function onBorderColorChanged() { canvas.requestPaint() }
        }
    }
}
