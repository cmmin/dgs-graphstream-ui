import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

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


    // SCHEME SELECTION

    Item {
        id: paneScheme

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneDescription.bottom

        height: childrenRect.height

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

                    BasicComponents.Combo {

                        model: ["Showcase Communities", "Showcase Edges Cut", "Showcase Random Assignments"]

                        Layout.preferredWidth: 300
                        Layout.leftMargin: 15

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
    } // END PANE

    Item {
        id: paneInputs
        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneScheme.bottom
        height: childrenRect.height

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
                        id: txtInputs
                        text: "Inputs"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtInputs.paintedWidth * 2
                        Layout.leftMargin: 10
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // input graph
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Graph File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        TextField {
                            id: txtGraphFilePath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtGraphFilePath.pathValid ? "black" : "#E24670"

                            text: "../../dgs-graphstream/inputs/network_1.txt"

                            background: Rectangle {
                                color: "white"
                                border.color: "#BFBFBF"
                                border.width: 1
                            }

                            onTextChanged: {
                                simulationParams.slotSetGraphFilePath(txtGraphFilePath.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetGraphFilePath(txtGraphFilePath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyGraphFilePathChanged: {
                                    txtGraphFilePath.pathValid = fileExistsAtPath
                                }
                            }
                        }

                        Text {
                            text: "Graph Format"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {

                            model: ["metis", "edgelist", "gml"]

                            Layout.preferredWidth: 150
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotGraphFormat('metis')
                                }
                                if(index === 1) {
                                    // edges-cut
                                    simulationParams.slotGraphFormat('edgelist')
                                }
                                if(index === 2) {
                                    // random
                                    simulationParams.slotGraphFormat('gml')
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Text {
                        id: txtFullGraphPath

                        property string path: ""
                        property string errorStr: "<b>File Doesn't Exist</b>: "
                        property bool showError: false

                        Layout.leftMargin: 15

                        text: txtFullGraphPath.showError ? txtFullGraphPath.errorStr + txtFullGraphPath.path : txtFullGraphPath.path
                        font.family: "Open Sans"
                        font.pixelSize: 10
                        color: txtFullGraphPath.showError ? "#E24670" : "#858585"

                        Connections {
                            target: simulationParams
                            onNotifyGraphFilePathChanged: {
                                txtFullGraphPath.path = graphFilePath
                                txtFullGraphPath.showError = !fileExistsAtPath
                            }
                        }
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

}
