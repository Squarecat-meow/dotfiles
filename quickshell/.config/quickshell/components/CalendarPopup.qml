import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    id: calendarRoot

    color: "transparent"
    radius: 12

    property date viewDate: new Date()
    property date today: new Date()

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }

    function firstDayOfWeek(year, month) {
        return new Date(year, month, 1).getDay();
    }

    // Refresh today at midnight
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: calendarRoot.today = new Date()
    }

    implicitHeight: calCol.implicitHeight + 8

    Column {
        id: calCol
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 4
        spacing: 4

        // Month navigation
        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 28

            Text {
                text: "\u25C0"
                color: Theme.dimColor
                font.pixelSize: 14
                font.family: Theme.fontFamily
                Layout.preferredWidth: 28
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        var d = calendarRoot.viewDate;
                        calendarRoot.viewDate = new Date(d.getFullYear(), d.getMonth() - 1, 1);
                    }
                    onEntered: parent.color = Theme.fgColor
                    onExited: parent.color = Theme.dimColor
                }
            }

            Text {
                text: calendarRoot.viewDate.getFullYear() + "\uB144 " + (calendarRoot.viewDate.getMonth() + 1) + "\uC6D4"
                color: Theme.fgColor
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            Text {
                text: "\u25B6"
                color: Theme.dimColor
                font.pixelSize: 14
                font.family: Theme.fontFamily
                Layout.preferredWidth: 28
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        var d = calendarRoot.viewDate;
                        calendarRoot.viewDate = new Date(d.getFullYear(), d.getMonth() + 1, 1);
                    }
                    onEntered: parent.color = Theme.fgColor
                    onExited: parent.color = Theme.dimColor
                }
            }
        }

        // Day-of-week headers
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            Repeater {
                model: ["\uC77C", "\uC6D4", "\uD654", "\uC218", "\uBAA9", "\uAE08", "\uD1A0"]
                Text {
                    width: Math.floor((calendarRoot.width) / 7)
                    text: modelData
                    color: index === 0 ? Theme.urgentColor : (index === 6 ? Theme.accentColor : Theme.dimColor)
                    font.pixelSize: 11
                    font.family: Theme.fontFamily
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Date grid
        Grid {
            id: dateGrid
            columns: 7
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            property int year: calendarRoot.viewDate.getFullYear()
            property int month: calendarRoot.viewDate.getMonth()
            property int numDays: calendarRoot.daysInMonth(year, month)
            property int startDay: calendarRoot.firstDayOfWeek(year, month)
            property int totalCells: startDay + numDays
            property int rows: Math.ceil(totalCells / 7)
            property real cellWidth: Math.floor((calendarRoot.width) / 7)

            Repeater {
                model: dateGrid.rows * 7

                Item {
                    width: dateGrid.cellWidth
                    height: 24

                    property int dayNum: index - dateGrid.startDay + 1
                    property bool isValid: dayNum >= 1 && dayNum <= dateGrid.numDays
                    property bool isToday: isValid
                        && dayNum === calendarRoot.today.getDate()
                        && dateGrid.month === calendarRoot.today.getMonth()
                        && dateGrid.year === calendarRoot.today.getFullYear()
                    property bool isSunday: index % 7 === 0
                    property bool isSaturday: index % 7 === 6

                    Rectangle {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        radius: 11
                        color: parent.isToday ? Theme.accentColor : "transparent"
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.isValid ? parent.dayNum : ""
                        color: parent.isToday ? Theme.bgSolid :
                               parent.isSunday ? Theme.urgentColor :
                               parent.isSaturday ? Theme.accentColor :
                               Theme.fgColor
                        font.pixelSize: 12
                        font.family: Theme.fontFamily
                        font.bold: parent.isToday
                    }
                }
            }
        }
    }
}
