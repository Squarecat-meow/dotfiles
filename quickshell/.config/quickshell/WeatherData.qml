pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    property string currentWeather: "..."
    property var forecast: []

    readonly property var weatherIcons: ({
        "113": "\u2600\uFE0F",
        "116": "\u26C5",
        "119": "\u2601\uFE0F",
        "122": "\u2601\uFE0F",
        "143": "\uD83C\uDF2B\uFE0F",
        "176": "\uD83C\uDF26\uFE0F",
        "179": "\uD83C\uDF28\uFE0F",
        "182": "\uD83C\uDF28\uFE0F",
        "200": "\u26C8\uFE0F",
        "227": "\uD83C\uDF28\uFE0F",
        "230": "\u2744\uFE0F",
        "248": "\uD83C\uDF2B\uFE0F",
        "260": "\uD83C\uDF2B\uFE0F",
        "263": "\uD83C\uDF26\uFE0F",
        "266": "\uD83C\uDF27\uFE0F",
        "293": "\uD83C\uDF26\uFE0F",
        "296": "\uD83C\uDF27\uFE0F",
        "299": "\uD83C\uDF27\uFE0F",
        "302": "\uD83C\uDF27\uFE0F",
        "305": "\uD83C\uDF27\uFE0F",
        "308": "\uD83C\uDF27\uFE0F",
        "311": "\uD83C\uDF27\uFE0F",
        "314": "\uD83C\uDF27\uFE0F",
        "317": "\uD83C\uDF28\uFE0F",
        "320": "\uD83C\uDF28\uFE0F",
        "323": "\uD83C\uDF28\uFE0F",
        "326": "\uD83C\uDF28\uFE0F",
        "329": "\u2744\uFE0F",
        "332": "\u2744\uFE0F",
        "335": "\u2744\uFE0F",
        "338": "\u2744\uFE0F",
        "350": "\uD83C\uDF28\uFE0F",
        "353": "\uD83C\uDF26\uFE0F",
        "356": "\uD83C\uDF27\uFE0F",
        "359": "\uD83C\uDF27\uFE0F",
        "362": "\uD83C\uDF28\uFE0F",
        "365": "\uD83C\uDF28\uFE0F",
        "368": "\uD83C\uDF28\uFE0F",
        "371": "\u2744\uFE0F",
        "374": "\uD83C\uDF28\uFE0F",
        "377": "\uD83C\uDF28\uFE0F",
        "386": "\u26C8\uFE0F",
        "389": "\u26C8\uFE0F",
        "392": "\u26C8\uFE0F",
        "395": "\u26C8\uFE0F"
    })

    function getIcon(code) {
        return weatherIcons[code] || "\u2601\uFE0F"
    }

    property string _buffer: ""

    property var _proc: Process {
        id: weatherProc
        command: ["curl", "-s", "--max-time", "10", "wttr.in/Yongin?format=j1"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => { _buffer += data }
        }
        onRunningChanged: {
            if (!running && _buffer.length > 0) {
                try {
                    var json = JSON.parse(_buffer)
                    var root = json.data || json

                    // Current weather
                    var cur = root.current_condition[0]
                    var curIcon = getIcon(cur.weatherCode)
                    currentWeather = curIcon + " " + cur.temp_C + "\u00B0C"

                    // 3-day forecast
                    var weather = root.weather
                    if (!weather || weather.length < 3) return

                    var labels = ["오늘", "내일", "모레"]
                    var result = []
                    for (var i = 0; i < 3; i++) {
                        var day = weather[i]
                        var code = day.hourly[4].weatherCode || "116"
                        result.push({
                            label: labels[i],
                            icon: getIcon(code),
                            maxTemp: day.maxtempC,
                            minTemp: day.mintempC
                        })
                    }
                    forecast = result
                } catch (e) {
                    console.warn("WeatherData: parse failed:", e)
                }
                _buffer = ""
            }
        }
    }

    property var _timer: Timer {
        interval: 3600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProc.running = true
    }
}
