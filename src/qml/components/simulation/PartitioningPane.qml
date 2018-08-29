import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

    property string scheme: ""
    property string clustering: ""

    Connections {
        target: simulationParams
        onNotifySchemeChanged: {
            root.scheme = scheme
        }
        onNotifyClusteringChanged: {
            root.clustering = clustering
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
        text: "some loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this panesome loong text that describes this pane"
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

                    // input graph
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Assignments File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                            color: !chbxRandomAssignments.checked ? "black" : "#858585"
                        }

                        BasicComponents.Textfield {
                            id: txtAssignmentsFilePath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: !chbxRandomAssignments.checked ? txtAssignmentsFilePath.pathValid ? "black" : "#E24670" : "#858585"

                            text: "../../dgs-graphstream/inputs/assignments.txt"
                            enabled: !chbxRandomAssignments.checked

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
                                }
                            }
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

                        Connections {
                            target: simulationParams
                            onNotifyAssignmentsFilePathChanged: {
                                txtFullAssignmentsPath.path = assignmentsPath
                                txtFullAssignmentsPath.showError = !fileExistsAtPath
                            }
                        }
                    }

                    // partition seed
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: txtPartitionSeed
                            property int seedValue: 0
                            text: "Partition Random Seed: <b>" + String(txtPartitionSeed.seedValue) + "</b>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyPartitionSeedChanged: {
                                    txtPartitionSeed.seedValue = randomSeed
                                }
                            }

                            Component.onCompleted: {
                                btnGeneratePartitionSeed.generateNewSeed()
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGeneratePartitionSeed

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

                    // random assignments
                    RowLayout {
                        Text {
                            text: "Enable Random Assignments"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Checkbox {
                            id: chbxRandomAssignments
                            onCheckedChanged: {
                                simulationParams.slotSetRandomAssignments(chbxRandomAssignments.checked)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetRandomAssignments(chbxRandomAssignments.checked)
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // slider num partitions
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Number of Partitions"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxRandomAssignments.checked ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrNumPartitions

                            from: 1
                            to: 20
                            value: 4
                            stepSize: 1

                            enabled: chbxRandomAssignments.checked

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetNumPartitions(sldrNumPartitions.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetNumPartitions(sldrNumPartitions.value)
                            }

                        }

                        Text {
                            id: txtNumPartitions
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxRandomAssignments.checked ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyNumPartitionsChanged: {
                                    txtNumPartitions.text = String(numPartitions)
                                }
                            }
                        }


                        Item {Layout.fillWidth: true}
                    }

                    // load imbalance
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Load Imbalance"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxRandomAssignments.checked ? "black" : "#858585"
                        }

                        BasicComponents.Slider {
                            id: sldrLoadImbalance

                            from: 1.0
                            to: 2.0
                            value: 1.001
                            stepSize: 0.001

                            enabled: chbxRandomAssignments.checked

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetLoadImbalance(sldrLoadImbalance.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetLoadImbalance(sldrLoadImbalance.value)
                            }
                        }

                        Text {
                            id: txtLoadImbalance
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxRandomAssignments.checked ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyLoadImbalanceChanged: {
                                    txtLoadImbalance.text = String(loadImbalance)
                                }
                            }
                        }


                        Item {Layout.fillWidth: true}
                    }

                    // partition weights
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Partition Weights"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxRandomAssignments.checked ? "black" : "#858585"
                        }

                        BasicComponents.Textfield {
                            id: txtPartitionWeights
                            Layout.preferredWidth: 300
                            property bool valid: true

                            color: txtPartitionWeights.valid ? "black" : "#E24670"

                            text: "0.25,0.25,0.25,0.25"

                            enabled: chbxRandomAssignments.checked


                            onTextChanged: {
                                simulationParams.slotSetPartitionWeightsChanged(txtPartitionWeights.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetPartitionWeightsChanged(txtPartitionWeights.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyPartitionWeights: {
                                    txtPartitionWeights.valid = isValid
                                }
                            }
                        }

                        Text {
                            color: chbxRandomAssignments.checked ? "black" : "#858585"
                            text: "format: w1,w2,...wn where n=Number of Partitions; sum(w) = 1.0"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // visible partitions
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Visible Partitions"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtVisiblePartitions
                            Layout.preferredWidth: 200
                            property bool valid: true

                            color: txtVisiblePartitions.valid ? "black" : "#E24670"

                            text: ""

                            onTextChanged: {
                                simulationParams.slotSetVisiblePartitions(txtVisiblePartitions.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetVisiblePartitions(txtVisiblePartitions.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyVisiblePartitionsChanged: {
                                    txtVisiblePartitions.valid = isValid
                                }
                            }
                        }

                        Text {
                            color: chbxRandomAssignments.checked ? "black" : "#858585"
                            text: "format: p1,p2,..pn where pi=partition number"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

    Item {
        id: paneClustering

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: panePartitioning.bottom

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
                        id: txtClustering
                        text: "Clustering Properties"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtClustering.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // clustering scheme
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Clustering Method"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Combo {

                            model: ["oslom2", "infomap", "graphviz"]

                            Layout.preferredWidth: 150
                            Layout.leftMargin: 15

                            onActivated: {
                                if(index === 0) {
                                    // communities
                                    simulationParams.slotSetClusteringMode('oslom2')
                                }
                                if(index === 1) {
                                    // edges-cut
                                    simulationParams.slotSetClusteringMode('infomap')
                                }
                                if(index === 2) {
                                    // random
                                    simulationParams.slotSetClusteringMode('graphviz')
                                }
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetClusteringMode('oslom2')
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // clustering seed
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            id: txtClusteringSeed
                            property int seedValue: 0
                            text: "Clustering Random Seed: <b>" + String(txtClusteringSeed.seedValue) + "</b>"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'edges-cut' || root.clustering === 'graphviz') {
                                    return "#858585"
                                }
                                else {
                                    return "black"
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyClusterSeedChanged: {
                                    txtClusteringSeed.seedValue = randomSeed
                                }
                            }

                            Component.onCompleted: {
                                btnGenerateClusteringSeed.generateNewSeed()
                            }

                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            id: btnGenerateClusteringSeed

                            function generateNewSeed() {
                                simulationParams.slotGenerateClusterSeed()
                            }

                            enabled: {
                                if(root.scheme === 'edges-cut' || root.clustering === 'graphviz') {
                                    return false
                                }
                                else {
                                    return true
                                }
                            }


                            text: "Generate Seed"
                            onClicked: {
                                btnGenerateClusteringSeed.generateNewSeed()
                            }
                        }

                        Text {
                            text: "not available with graphviz clustering or edges-cut scheme"
                            wrapMode: Text.WordWrap
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: "#858585"

                            visible: {
                                if(root.scheme === 'edges-cut' || root.clustering === 'graphviz') {
                                    return true
                                }
                                else {
                                    return false
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // infomap calls
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Infomap Calls"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return "black"
                                }
                                else {
                                    return "#858585"
                                }
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Slider {
                            id: sldrInfomapCalls
                            from: 0
                            to: 10
                            value: 0
                            stepSize: 1

                            Layout.preferredWidth: 200

                            enabled: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return true
                                }
                                else {
                                    return false
                                }
                            }

                            onValueChanged: {
                                simulationParams.slotSetInfomapCalls(sldrInfomapCalls.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetInfomapCalls(sldrInfomapCalls.value)
                            }
                        }

                        Text {
                            id: txtInfomapCalls
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return "black"
                                }
                                else {
                                    return "#858585"
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyInfomapCallsChanged: {
                                    txtInfomapCalls.text = String(infomapCalls)
                                }
                            }
                        }

                        Text {
                            text: "Available with oslom2 clustering and communities scheme"
                            wrapMode: Text.WordWrap
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: "#858585"

                            visible: {
                                if(root.scheme === 'communities' && root.clustering === 'oslom2') {
                                    return false
                                }
                                else {
                                    return true
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
