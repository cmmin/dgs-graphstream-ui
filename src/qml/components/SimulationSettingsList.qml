import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    color: "#F7F7F7"
    property string currentPaneCode: ""

    function addPane(paneTitle, paneCode) {
        paneModel.append({"paneTitle":paneTitle, "paneCode":paneCode})
    }

    ListModel {
        id: paneModel
    }


    signal changePane(string paneCode)

    onChangePane: {
        root.currentPaneCode = paneCode
    }

    ListView {
        id: view

        clip: true

        //anchors.fill: root

        width: parent.width
        height: root.height
        anchors.top: root.top
        anchors.left: root.left

        model: paneModel

        delegate: Rectangle {
            id: viewDelegate

            width: view.width
            height: 40

            color: (root.currentPaneCode === paneCode) ? "white" : root.color

            Text {
                text: paneTitle

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
                    root.changePane(paneCode)
                }
            }
        }
    }

    Rectangle {
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom
        width: 1
        color: "#BFBFBF"
    }

}
