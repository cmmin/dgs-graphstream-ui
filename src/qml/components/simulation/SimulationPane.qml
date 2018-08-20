import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

Item {
    id: root

    Text {
        id: paneTitle
        // Title
        text: "Simulation Settings & Parameters"
        font.family: "Ubuntu"
        font.pixelSize: 18
        color: "#333"

        anchors.left: root.left
        anchors.top: root.top

        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    Text {
        id: paneDescription
        text: "The basic parameters for generating a simulation are set here."
        font.family: "Open Sans"
        font.pixelSize: 14

        anchors.left: root.left
        anchors.top: paneTitle.bottom
        anchors.right: root.right

        anchors.leftMargin: 10
        anchors.topMargin: 10

        wrapMode: Text.WordWrap
    }

    Item {
        id: paneScheme
        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneDescription.bottom

        ColumnLayout {
            width: parent.width

            Rectangle {
                radius: 5
                color: "#F7F7F7"

                Layout.fillWidth: true
                Layout.margins: 10
                Layout.preferredHeight: childrenRect.height

                ColumnLayout {
                    width: parent.width

                    // contents go here
                    Text {
                        id: txtLayout
                        text: "Layout Scheme"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtLayout.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    ComboBox {

                        model: ["Showcase Communities", "Showcase Edges Cut", "Showcase Random Assignments"]

                        Layout.preferredWidth: 300
                        Layout.leftMargin: 15

                        background: Rectangle {
                            color: "white"
                            border.color: "#BFBFBF"
                            border.width: 1
                        }

                        onActivated: {
                            if(index === 0) {
                                // communities
                                simulationParams.slotSetScheme('communities')
                            }
                            if(index === 1) {
                                // edges-cut
                                simulationParams.slotSetScheme('edges-cut')
                            }
                            if(index === 2) {
                                // random
                                simulationParams.slotSetScheme('random')
                            }
                        }
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    }
}
