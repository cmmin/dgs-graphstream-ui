import QtQuick 2.7
import QtQuick.Controls 2.2

Slider {
    id: root

    snapMode: Slider.SnapOnRelease
    live: true

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: root.availableWidth
        height: implicitHeight
        radius: 2
        color: "white"

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            color: "#BFBFBF"
            radius: 2
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: root.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }

}
