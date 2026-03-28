import QtQuick
import ".."

Item {
    id: root
    implicitWidth: Math.max(metrics.width, weatherText.implicitWidth)
    implicitHeight: weatherText.implicitHeight

    TextMetrics {
        id: metrics
        font: weatherText.font
        text: "\uD83C\uDF24\uFE0F +00\u00B0C"
    }

    Text {
        id: weatherText
        width: root.implicitWidth
        text: WeatherData.currentWeather
        color: Theme.fgColor
        font.pixelSize: Theme.fontSize - 1
        font.family: Theme.fontFamily
        horizontalAlignment: Text.AlignHCenter

        Behavior on color { ColorAnimation { duration: 300 } }
    }
}
