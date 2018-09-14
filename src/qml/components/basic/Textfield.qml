import QtQuick 2.7
import QtQuick.Controls 2.2

TextField {
    id: root

    background: Rectangle {
        color: "white"
        border.color: "#BFBFBF"
        border.width: 1
    }

    //color: root.enabled ? "black" : "#858585"
    //color:  "#858585"

    selectByMouse: true
}
