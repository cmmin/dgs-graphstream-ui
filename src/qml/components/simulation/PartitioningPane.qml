import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import "./../basic/" as BasicComponents

Item {
    id: root

    property string scheme: ""
    property string clustering: ""
    property string assignmentsMode: "metis"

    Connections {
        target: simulationParams
        onNotifySchemeChanged: {
            root.scheme = scheme
        }
        onNotifyClusteringChanged: {
            root.clustering = clustering
        }
        onNotifyAssignmentModeChanged: {
            root.assignmentsMode = assignmentsMode
        }
    }

    Text {
        id: paneTitle
        // Title
        text: "Partitioning Settings"
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
        text: "Properties about how the nodes should be partitioned and separated."
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
        id: panePartitioning

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
                        text: "Partitioning Properties"
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

                    // partitioning mode
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Partitioning Method"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'cut-edges') {
                                    return "#858585"
                                }
                                else {
                                    return "black"
                                }
                            }
                        }

                        BasicComponents.Combo {
                            id: cmbxRandomAssignments


                            //model: ["Random Assignments", "From Assignments File"]
                            model: ["METIS Partitioning", "Random Assignments", "From Assignments File"]


                            //property bool checked: false

                            Layout.preferredWidth: 300
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 1) {
                                    // random
                                    simulationParams.slotSetAssignmentsMode('random')
                                }
                                if(index === 2) {
                                    simulationParams.slotSetAssignmentsMode('file')
                                }
                                if(index === 0) {
                                    // metis
                                    simulationParams.slotSetAssignmentsMode('metis')
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyAssignmentModeChanged: {
                                    var targetIndex = 0
                                    if(assignmentsMode === 'random') {
                                        targetIndex = 1
                                    }
                                    if(assignmentsMode === 'file') {
                                        targetIndex = 2
                                    }
                                    if(assignmentsMode === 'metis') {
                                        targetIndex = 0
                                    }

                                    if(cmbxRandomAssignments.currentIndex !== targetIndex) {
                                        cmbxRandomAssignments.currentIndex = targetIndex
                                    }

                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipColorClustering')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Item {Layout.fillWidth: true}
                    }


                    // input graph
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Assignments File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                            color: root.assignmentsMode === 'file' ? "black" : "#858585"
                        }

                        BasicComponents.Textfield {
                            id: txtAssignmentsFilePath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: root.assignmentsMode === 'file' ? (txtAssignmentsFilePath.pathValid ? "black" : "#E24670") : "#858585"

                            enabled: root.assignmentsMode === 'file'

                            onTextChanged: {
                                simulationParams.slotSetAssignmentsFilePath(txtAssignmentsFilePath.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetAssignmentsFilePath(txtAssignmentsFilePath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyAssignmentsFilePathChanged: {
                                    txtAssignmentsFilePath.pathValid = fileExistsAtPath
                                    if(txtAssignmentsFilePath.text !== assignmentsPath) {
                                        txtAssignmentsFilePath.text = assignmentsPath
                                    }
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipAssignmentsFilePath')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Text {
                        id: txtFullAssignmentsPath

                        property string path: ""
                        property string errorStr: "<b>File Doesn't Exist</b>: "
                        property bool showError: false

                        Layout.leftMargin: 15

                        text: txtFullAssignmentsPath.showError ? txtFullAssignmentsPath.errorStr + txtFullAssignmentsPath.path : txtFullAssignmentsPath.path
                        font.family: "Open Sans"
                        font.pixelSize: 10
                        color: txtFullAssignmentsPath.showError ? "#E24670" : "#858585"

                        visible: txtFullAssignmentsPath.path.length > 0

                        Connections {
                            target: simulationParams
                            onNotifyAssignmentsFilePathChanged: {
                                txtFullAssignmentsPath.path = assignmentsPath
                                txtFullAssignmentsPath.showError = !fileExistsAtPath
                            }
                        }
                    }

                    // slider num partitions
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Number of Partitions"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.assignmentsMode !== 'file' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrNumPartitions

                            from: 1
                            to: 12
                            value: 4
                            stepSize: 1

                            enabled: root.assignmentsMode !== 'file'

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetNumPartitions(sldrNumPartitions.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyNumPartitionsChanged: {
                                    if(sldrNumPartitions.value !== numPartitions) {
                                        sldrNumPartitions.value = numPartitions
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtNumPartitions
                            text: "4"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.assignmentsMode !== 'file' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyNumPartitionsChanged: {
                                    txtNumPartitions.text = String(numPartitions)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
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


                    // load imbalance
                    RowLayout {
                        Layout.fillWidth: true

                        visible: switchAdvanceMode.checked

                        Text {
                            text: "Partitioning Imbalance"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.assignmentsMode === 'metis' ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrLoadImbalance

                            from: 1
                            to: 5
                            value: 1
                            stepSize: 1

                            enabled: root.assignmentsMode === 'metis'

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetLoadImbalance(sldrLoadImbalance.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyLoadImbalanceChanged: {
                                    if(sldrLoadImbalance.value !== loadImbalance) {
                                        sldrLoadImbalance.value = loadImbalance
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtLoadImbalance
                            text: "1%"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.assignmentsMode === 'metis' ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyLoadImbalanceChanged: {
                                    txtLoadImbalance.text = String(loadImbalance) + "%"
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipPartitionsImbalance')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // partition weights
                    RowLayout {
                        Layout.fillWidth: true
                        visible: switchAdvanceMode.checked

                        Text {
                            text: "Partition Weights"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: root.assignmentsMode !== 'file' ? "black" : "#858585"
                        }

                        BasicComponents.Textfield {
                            id: txtPartitionWeights
                            Layout.preferredWidth: 300
                            property bool valid: true

                            color: txtPartitionWeights.valid ? (txtPartitionWeights.enabled ? "black" : "#858585") : "#E24670"

                            enabled: root.assignmentsMode !== 'file'

                            function computeValue(numPartitions) {
                              var partWeightNum = 1.0 / (1.0 * numPartitions)
                              var partWeight = String(partWeightNum).substr(0, 5)
                              var s = partWeight
                              for(var i = 1; i < numPartitions; i++) {
                                  s += ',' + partWeight
                              }
                              txtPartitionWeights.text = s
                            }


                            onTextChanged: {
                                simulationParams.slotSetPartitionWeightsChanged(txtPartitionWeights.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyPartitionWeights: {
                                    txtPartitionWeights.valid = isValid
                                }
                                onNotifyNumPartitionsChanged: {
                                  txtPartitionWeights.computeValue(numPartitions)
                                }
                            }

                            Component.onCompleted: {
                              txtPartitionWeights.computeValue(4)
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipPartitionWeights')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Text {
                            color: root.assignmentsMode !== 'file' ? "black" : "#858585"
                            text: "format: w1,w2,...wn where n=Number of Partitions; sum(w) = 1.0"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // visible partitions
                    RowLayout {
                        Layout.fillWidth: true
                        visible: switchAdvanceMode.checked

                        Text {
                            text: "Visible Partitions"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            //color: cmbxRandomAssignments.checked ? "black" : "#858585"
                        }

                        BasicComponents.Textfield {
                            id: txtVisiblePartitions
                            Layout.preferredWidth: 200
                            property bool valid: true
                            color: txtVisiblePartitions.valid ? "black" : "#E24670"
                            //enabled: cmbxRandomAssignments.checked

                            text: ""

                            onTextChanged: {
                                simulationParams.slotSetVisiblePartitions(txtVisiblePartitions.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetVisiblePartitions(txtVisiblePartitions.text)
                                txtVisiblePartitions.computeVisible(4)
                            }

                            function computeVisible(numPartitions) {
                              var offset = 1
                              var s = String(offset)
                              //var remainder = 1.0 - parseFloat(partWeight)
                              for(var i = 1; i < numPartitions; i++) {
                                  s += ',' + String(i + offset)
                              }
                              txtVisiblePartitions.text = s
                            }

                            Connections {
                                target: simulationParams
                                onNotifyVisiblePartitionsChanged: {
                                    txtVisiblePartitions.valid = isValid
                                }
                                onNotifyNumPartitionsChanged: {
                                  txtVisiblePartitions.computeVisible(numPartitions)
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipVisiblePartitions')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Text {
                            //color: cmbxRandomAssignments.checked ? "black" : "#858585"
                            text: "format: p1,p2,..pn where pi=partition number"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // partition seed
                    RowLayout {
                        Layout.fillWidth: true
                        visible: switchAdvanceMode.checked

                        Text {
                            color: root.assignmentsMode === 'random' ? "black" : "#858585"
                            property int seedValue: 0
                            text: "Partition Random Seed"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtPartitioningSeed
                            Layout.preferredWidth: 100
                            text: ""
                            color: txtPartitioningSeed.valid === false ? "#E24670" : (txtPartitioningSeed.enabled ? "black" : "#858585")

                            property bool disableUpdate: false
                            property bool valid: true

                            enabled: root.assignmentsMode === 'random'
                            onTextChanged: {
                                if (txtPartitioningSeed.disableUpdate === false) {
                                    simulationParams.slotSetPartitionSeed(txtPartitioningSeed.text)
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyPartitionSeedChanged: {
                                    txtPartitioningSeed.text = randomSeed
                                    txtPartitioningSeed.valid = isValid
                                }
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGeneratePartitionSeed

                            enabled: root.assignmentsMode === 'random'

                            function generateNewSeed() {
                                simulationParams.slotGeneratePartitionSeed()
                            }

                            text: "Generate Seed"
                            onClicked: {
                                btnGeneratePartitionSeed.generateNewSeed()
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
