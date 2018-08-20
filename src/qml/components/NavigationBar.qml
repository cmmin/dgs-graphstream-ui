import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: root

    height: 40

    property string currentPageTitle: ""
    property string currentPageCode: ""

    RowLayout {
        anchors.fill: parent

        Item {width:1} // spacer

        // Page Title
        Text {
            id: txtTitle
            text: "DGS GRAPHSTREAM: " + root.currentPageTitle
            font.family: "Ubuntu"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignVCenter
        }

        Item {Layout.fillWidth: true} // filler spacer

        // Settings button

        Item {width:1} // spacer
    }

    Rectangle {
        id: bottomBorderLine
        height: 1
        color: "#333333"
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
    }
}
