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

    property bool checked: false

    // current active button pane code
    property string currentPaneCode: ""

    color: (root.currentPaneCode === root.paneCode) ? root.colorChecked : root.colorUnchecked

    signal clicked(string paneCode)

    Text {
        text: root.paneTitle

        anchors.centerIn: parent
        wrapMode: Text.WrapAnywhere
    }

    Image {
        anchors.verticalCenter: root.verticalCenter
        anchors.right: root.right
        anchors.rightMargin: 10

        //source: root.checked ? "../assets/icons/chevron_down_light.png" : "../assets/icons/chevron_right_light.png"
        source: "../assets/icons/chevron.png"
        width: 20; height: 20;
        fillMode: Image.PreserveAspectFit

        transformOrigin: Item.Center
        rotation: root.checked ? 90 : 0
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
