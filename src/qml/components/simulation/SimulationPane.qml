import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

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
                        text: "Simulation"
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

                    RowLayout {

                        Text {
                            text: "Simulation Mode"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                      BasicComponents.Combo {
                          id: cmbxScheme
                          model: ["Showcase Communities", "Showcase Edges Cut"]

                          Layout.preferredWidth: 300
                          Layout.leftMargin: 15

                          onActivated: {
                              if(index === 0) {
                                  // communities
                                  simulationParams.slotSetScheme('communities')
                              }
                              if(index === 1) {
                                  // cut-edges
                                  simulationParams.slotSetScheme('cut-edges')
                              }
                          }

                          Connections {
                              target: simulationParams
                              onNotifySchemeChanged: {
                                  if (scheme === 'communities') {
                                      cmbxScheme.currentIndex = 0
                                  }
                                  else {
                                      cmbxScheme.currentIndex = 1
                                  }
                              }
                          }
                      }

                      BasicComponents.TooltipIcon {
                          text: uiTexts.get('tooltipScheme')
                          Layout.preferredWidth: 24
                          Layout.preferredHeight: 24
                      }
                      Item {Layout.fillWidth: true}
                    }

                    // input graph
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: lblGraphFilePath
                            text: "Graph File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtGraphFilePath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtGraphFilePath.pathValid ? "black" : "#E24670"

                            onTextChanged: {
                                simulationParams.slotSetGraphFilePath(txtGraphFilePath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyGraphFilePathChanged: {
                                    txtGraphFilePath.pathValid = fileExistsAtPath
                                    if (txtGraphFilePath.text !== graphFilePath) {
                                        txtGraphFilePath.text = graphFilePath
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Graph Format"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {
                            id: cmbxGraphFormat
                            model: ["metis", "edgelist", "gml"]

                            Layout.preferredWidth: 150
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotGraphFormat('metis')
                                }
                                if(index === 1) {
                                    // cut-edges
                                    simulationParams.slotGraphFormat('edgelist')
                                }
                                if(index === 2) {
                                    // random
                                    simulationParams.slotGraphFormat('gml')
                                }
                            }
                            Connections {
                                target:simulationParams
                                onNotifyGraphFormatChanged: {
                                    if(format === 'metis') {
                                        cmbxGraphFormat.currentIndex = 0
                                    }
                                    else if(format === 'edgelist') {
                                        cmbxGraphFormat.currentIndex = 1
                                    }
                                    else {
                                        cmbxGraphFormat.currentIndex = 2
                                    }
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

                        visible: txtFullGraphPath.path.length > 0

                        Connections {
                            target: simulationParams
                            onNotifyGraphFilePathChanged: {
                                txtFullGraphPath.path = graphFilePath
                                txtFullGraphPath.showError = !fileExistsAtPath
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Advanced Options"
                            Layout.leftMargin: 15
                            font.family: "Open Sans"
                        }

                        BasicComponents.SimpleSwitch {
                            id: switchAdvanceMode
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

    Item {
        id: paneArrivals
        anchors.left: root.left
        anchors.right: root.right

        visible: switchAdvanceMode.checked

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
                        id: txtSequence
                        text: "Sequence of Node Arrival"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtSequence.paintedWidth * 2
                        Layout.leftMargin: 10
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // Node order list
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Node Order List File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: (txtNoderOrderList.text.length > 0 && txtNoderOrderList.pathValid === true) ? "black" : "#858585"

                        }

                        BasicComponents.Textfield {
                            id: txtNoderOrderList
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtNoderOrderList.pathValid ? "black" : "#E24670"

                            text: "../../dgs-graphstream/inputs/arrival_100_1.txt"

                            onTextChanged: {
                                //console.log('txtNoderOrderList.text', txtNoderOrderList.text)
                                simulationParams.slotSetNodeOrderListPath(txtNoderOrderList.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyNodeOrderListPathChanged: {
                                    txtNoderOrderList.pathValid = pathValid
                                    if(txtNoderOrderList.text !== orderListPath) {
                                        txtNoderOrderList.text = orderListPath
                                    }
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipNodeOrderFilePath')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
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
                                txtNoderOrderListPath.showError = !pathValid && orderListPath.length > 0
                            }
                        }
                    }

                    // Ordering seed
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            property int seedValue: 0
                            text: "Node Order Random Seed"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: (txtNoderOrderList.text.length === 0 || txtNoderOrderList.pathValid === false) ? "black" : "#858585"

                            /*Component.onCompleted: {
                                btnGenerateOrderSeed.generateNewSeed()
                            }*/
                        }

                        BasicComponents.Textfield {
                            id: txtOrderingSeed
                            Layout.preferredWidth: 100
                            text: ""
                            color: txtOrderingSeed.valid === false ? "#E24670" : (txtOrderingSeed.enabled ? "black" : "#858585")

                            property bool disableUpdate: false
                            property bool valid: true

                            enabled: (txtNoderOrderList.text.length === 0 || txtNoderOrderList.pathValid === false)

                            onTextChanged: {
                                if (txtOrderingSeed.disableUpdate === false) {
                                    simulationParams.slotSetOrderSeed(txtOrderingSeed.text)
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyOrderSeedChanged: {
                                    txtOrderingSeed.text = randomSeed
                                    txtOrderingSeed.valid = isValid
                                }
                            }
                        }



                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateOrderSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateOrderSeed()
                            }

                            enabled: (txtNoderOrderList.text.length === 0 || txtNoderOrderList.pathValid === false)


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

    Item {
        id: paneMoreInputs
        anchors.left: root.left
        anchors.right: root.right

        visible: switchAdvanceMode.checked

        anchors.top: paneArrivals.bottom
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
                        id: txtAdditionalInputs
                        text: "Additional Input Parameters"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtAdditionalInputs.paintedWidth * 2
                        Layout.leftMargin: 10
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}


                    // Filter List
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Nodes to ignore File Path"
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

                            /*Component.onCompleted: {
                                simulationParams.slotSetFilterPath(txtFilterListPath.text)
                            }*/

                            Connections {
                                target: simulationParams
                                onNotifyFilterPathChanged: {
                                    txtFilterListPath.pathValid = pathValid
                                    if(txtFilterListPath.text !== filterPath) {
                                        txtFilterListPath.text = filterPath
                                    }
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipNodesIgnoreFilePath')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
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
                                txtFullFilterPath.showError = !pathValid && filterPath.length > 0
                            }
                        }
                    }

                    // Weight attribute
                    RowLayout {
                        Layout.fillWidth: true

                        visible: false

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

                            /*Component.onCompleted: {
                                simulationParams.slotSetNodeWeightAttribute(txtNodeWeightAttribute.text)
                            }*/

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

                        visible: false

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

                            /*Component.onCompleted: {
                                simulationParams.slotSetEdgeWeightAttribute(txtEdgeWeightAttribute.text)
                            }*/

                            Connections {
                                target: simulationParams
                                onNotifyEdgeWeightAttributeChanged: {
                                    txtEdgeWeightAttribute.valid = isValid
                                }
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
