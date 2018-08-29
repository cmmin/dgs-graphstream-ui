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

                        model: ["Showcase Communities", "Showcase Edges Cut"]

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
                        }

                        Component.onCompleted: {
                            simulationParams.slotSetScheme('communities')
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

                        BasicComponents.Textfield {
                            id: txtGraphFilePath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtGraphFilePath.pathValid ? "black" : "#E24670"

                            text: "../../dgs-graphstream/inputs/network_1.txt"

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

                            Component.onCompleted: {
                                simulationParams.slotGraphFormat('metis')
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

                    // Node order list
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Order List File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtNoderOrderList
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtNoderOrderList.pathValid ? "black" : "#E24670"

                            text: "../../dgs-graphstream/inputs/arrival_100_1.txt"

                            onTextChanged: {
                                simulationParams.slotSetNodeOrderListPath(txtNoderOrderList.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetNodeOrderListPath(txtNoderOrderList.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyNodeOrderListPathChanged: {
                                    txtNoderOrderList.pathValid = pathValid
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Text {
                        id: txtNoderOrderListPath

                        property string path: ""
                        property string errorStr: "<b>File Doesn't Exist</b>: "
                        property bool showError: false

                        Layout.leftMargin: 15

                        text: txtNoderOrderListPath.showError ? txtNoderOrderListPath.errorStr + txtNoderOrderListPath.path : txtNoderOrderListPath.path
                        font.family: "Open Sans"
                        font.pixelSize: 10
                        color: txtNoderOrderListPath.showError ? "#E24670" : "#858585"

                        Connections {
                            target: simulationParams
                            onNotifyNodeOrderListPathChanged: {
                                txtNoderOrderListPath.path = orderListPath
                                txtNoderOrderListPath.showError = !pathValid
                            }
                        }
                    }


                    // Filter List
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Filter List File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtFilterListPath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtFilterListPath.pathValid ? "black" : "#E24670"

                            text: ""

                            onTextChanged: {
                                simulationParams.slotSetFilterPath(txtFilterListPath.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetFilterPath(txtFilterListPath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyFilterPathChanged: {
                                    txtFilterListPath.pathValid = pathValid
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Text {
                        id: txtFullFilterPath

                        property string path: ""
                        property string errorStr: "<b>File Doesn't Exist</b>: "
                        property bool showError: false

                        Layout.leftMargin: 15

                        text: txtFullFilterPath.showError ? txtFullFilterPath.errorStr + txtFullFilterPath.path : txtFullFilterPath.path
                        font.family: "Open Sans"
                        font.pixelSize: 10
                        color: txtFullFilterPath.showError ? "#E24670" : "#858585"

                        Connections {
                            target: simulationParams
                            onNotifyFilterPathChanged: {
                                txtFullFilterPath.path = filterPath
                                txtFullFilterPath.showError = !pathValid
                            }
                        }
                    }

                    // Weight attribute
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Weight Attribute"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtNodeWeightAttribute
                            Layout.preferredWidth: 150
                            property bool valid: true

                            color: txtNodeWeightAttribute.valid ? "black" : "#E24670"

                            text: "weight"

                            onTextChanged: {
                                simulationParams.slotSetNodeWeightAttribute(txtNodeWeightAttribute.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetNodeWeightAttribute(txtNodeWeightAttribute.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyNodeWeightAttributeChanged: {
                                    txtNodeWeightAttribute.valid = isValid
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // Edge attribute
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Edge Weight Attribute"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtEdgeWeightAttribute
                            Layout.preferredWidth: 150
                            property bool valid: true

                            color: txtEdgeWeightAttribute.valid ? "black" : "#E24670"

                            text: "weight"

                            onTextChanged: {
                                simulationParams.slotSetEdgeWeightAttribute(txtEdgeWeightAttribute.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetEdgeWeightAttribute(txtEdgeWeightAttribute.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyEdgeWeightAttributeChanged: {
                                    txtEdgeWeightAttribute.valid = isValid
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // clustering seed
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: txtOrderSeed
                            property int seedValue: 0
                            text: "Order Random Seed: <b>" + String(txtOrderSeed.seedValue) + "</b>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyOrderSeedChanged: {
                                    txtOrderSeed.seedValue = randomSeed
                                }
                            }

                            Component.onCompleted: {
                                btnGenerateOrderSeed.generateNewSeed()
                            }

                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateOrderSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateOrderSeed()
                            }

                            text: "Generate Seed"
                            onClicked: {
                                btnGenerateOrderSeed.generateNewSeed()
                            }
                        }
                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

}
