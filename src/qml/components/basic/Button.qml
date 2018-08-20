import QtQuick 2.7
import QtQuick.Controls 2.4

Button {
    id: control
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 26
        opacity: enabled ? 1 : 0.3
        border.color: "#BFBFBF"
        border.width: 1
        radius: 3
    }
}
