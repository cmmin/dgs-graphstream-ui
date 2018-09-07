import QtQuick 2.7
import QtQuick.Controls 2.1

ToolTip {
    id: control
    text: ""

    font.family: "Open Sans"
    delay: 650

    contentItem: Text {
        text: control.text
        font: control.font
        color: "black"
    }

    background: Rectangle {
        border.color: "#858585"
        color: "#F7F7F7"
        radius: 3
    }
}
