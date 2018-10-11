import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: root

    height: 40

    // this button pane code
    property string paneCode: ""
    property string paneTitle: ""

    property string colorChecked: "white"
    property string colorUnchecked:  "#F7F7F7"

    // current active button pane code
    property string currentPaneCode: ""

    color: (root.currentPaneCode === root.paneCode) ? root.colorChecked : root.colorUnchecked

    signal clicked(string paneCode)

    Text {
        text: root.paneTitle

        anchors.centerIn: parent
        wrapMode: Text.WrapAnywhere
    }

    Rectangle {
        height: 1

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "#BFBFBF"

        anchors.leftMargin: 10
        anchors.rightMargin: 10
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked(root.paneCode)
        }
    }
}
