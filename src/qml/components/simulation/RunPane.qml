import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import "./../basic/" as BasicComponents

Item {
    id: root

    property string assignmentsMode: ''
    property string clusterMode: ''
    property string scheme: ''
    property string nodeSizeMode: ''

    Text {
        id: paneTitle
        // Title
        text: "Generate DGS Graphstream"
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
        text: "Check the simulation parameters & run the simulation."
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
        id: paneDetails

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneDescription.bottom

        //height: childrenRect.height
        //anchors.bottom: paneProgramOutput.top
        anchors.bottom: paneProgramOutput.visible ? paneProgramOutput.top : paneControls.top

        //visible: btnStart.isRunning === false

        ColumnLayout {
            //width: parent.width

            anchors.fill: parent

            Rectangle {
                radius: 5
                color: "#F7F7F7"

                id: summaryPaneRect

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 10
                //Layout.preferredHeight: childrenRect.height

                ColumnLayout {
                    //width: parent.width
                    anchors.fill: parent

                    // contents go here
                    Text {
                        id: txtSummary
                        text: "Full Simulation Parameters"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtSummary.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    Flickable {
                        id: flk
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.margins: 5

                        property bool scrollActive: true

                        ScrollBar.vertical: ScrollBar {
                            id: flkSB
                            active: true
                            onActiveChanged: {
                                if(flkSB.active !== flk.scrollActive) {
                                    flkSB.active = flk.scrollActive
                                }
                            }
                         }


                        clip: true
                        contentWidth: flickableContent.width
                        contentHeight: flickableContent.height

                        Item {
                            id: flickableContent
                            width: summaryPaneRect.width
                            height: childrenRect.height
                            //height: 1000

                            GridLayout {
                                //width: parent.width
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10

                                columns: 3

                                Text { text: "Simulation Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Scheme"; font.family: "Ubuntu"; }
                                Text { id: txtScheme; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Graph File"; font.family: "Ubuntu"; }
                                Text { id: txtGraphFilePath; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Graph Format"; font.family: "Ubuntu"; }
                                Text { id: txtGraphFormat; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Output Folder"; font.family: "Ubuntu"; }
                                Text { id: txtOutputFolder; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}



                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Input File Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Node Order File Path"; font.family: "Ubuntu"; }
                                Text { id: txtNodeOrderListPath; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Filter Path"; font.family: "Ubuntu"; }
                                Text { id: txtFilterPath; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Ordering Seed"; font.family: "Ubuntu"; }
                                Text { id: txtOrderSeed; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                /*Text { text: "Node Weight Attribute"; font.family: "Ubuntu"; }
                                Text { id: txtNodeWeightAttribute; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Edge Weight Attribute"; font.family: "Ubuntu"; }
                                Text { id: txtEdgeWeightAttribute; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}*/


                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Partitioning Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Assignments Mode"; font.family: "Ubuntu"; }
                                Text { id: txtAssignmentsMode; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Assignments File Path"; font.family: "Ubuntu"; visible: root.assignmentsMode === 'file'; }
                                Text { id: txtAssignmentsFilePath; text: ""; font.family: "Open Sans"; visible: root.assignmentsMode === 'file'; }
                                Item {Layout.fillWidth: true; visible: root.assignmentsMode === 'file';}

                                Text { text: "Number of Partitions"; font.family: "Ubuntu"; visible: root.assignmentsMode !== 'file'; }
                                Text { id: txtNumPartitions; text: ""; font.family: "Open Sans"; visible: root.assignmentsMode !== 'file'; }
                                Item {Layout.fillWidth: true; visible: root.assignmentsMode !== 'file';}

                                Text { text: "Load Imbalance"; font.family: "Ubuntu"; visible: root.assignmentsMode === 'metis';}
                                Text { id: txtLoadImbalance; text: ""; font.family: "Open Sans"; visible: root.assignmentsMode === 'metis'; }
                                Item { Layout.fillWidth: true; visible: root.assignmentsMode === 'metis';}

                                Text { text: "Partition Weights"; font.family: "Ubuntu"; visible: root.assignmentsMode !== 'file'; }
                                Text { id: txtPartitionWeights; text: ""; font.family: "Open Sans"; visible: root.assignmentsMode !== 'file'; }
                                Item { Layout.fillWidth: true; visible: root.assignmentsMode !== 'file';}

                                Text { text: "Partition Seed"; font.family: "Ubuntu"; visible: root.assignmentsMode === 'random';}
                                Text { id: txtPartitionSeed; text: ""; font.family: "Open Sans"; visible: root.assignmentsMode === 'random';}
                                Item {Layout.fillWidth: true; visible: root.assignmentsMode === 'random';}

                                Text { text: "Visible Partitions"; font.family: "Ubuntu";}
                                Text { id: txtVisiblePartitions; text: ""; font.family: "Open Sans";}
                                Item { Layout.fillWidth: true;}




                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Clustering Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Clustering Mode"; font.family: "Ubuntu"; }
                                Text { id: txtClusteringMode; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Cluster Seed"; font.family: "Ubuntu"; visible: root.clusterMode !== 'graphviz' && root.scheme !== 'cut-edges';}
                                Text { id: txtClusteringSeed; text: ""; font.family: "Open Sans"; visible: root.clusterMode !== 'graphviz' && root.scheme !== 'cut-edges'; }
                                Item {Layout.fillWidth: true; visible: root.clusterMode !== 'graphviz' && root.scheme !== 'cut-edges';}

                                Text { text: "Infomap Calls"; font.family: "Ubuntu"; visible: root.clusterMode === 'oslom2' && root.scheme === 'communities'; }
                                Text { id: txtInfomapCalls; text: ""; font.family: "Open Sans"; visible: root.clusterMode === 'oslom2' && root.scheme === 'communities'; }
                                Item {Layout.fillWidth: true; visible: root.clusterMode === 'oslom2' && root.scheme === 'communities';}

                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Layout Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Graph Layout"; font.family: "Ubuntu"; }
                                Text { id: txtGraphLayout; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { visible: txtGraphLayout.text === 'linlog'; text: "Layout linlog Force"; font.family: "Ubuntu"; }
                                Text { id: txtLayoutLinlogForce; text: ""; visible: txtGraphLayout.text === 'linlog'; font.family: "Open Sans" }
                                Item { visible: txtGraphLayout.text === 'linlog'; Layout.fillWidth: true}

                                Text { text: "Layout Attraction"; font.family: "Ubuntu"; }
                                Text { id: txtLayoutAttraction; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Layout Repulsion"; font.family: "Ubuntu"; }
                                Text { id: txtLayoutRepulsion; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Layout Seed"; font.family: "Ubuntu"; }
                                Text { id: txtLayoutSeed; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}



                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Coloring Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Color Scheme"; font.family: "Ubuntu"; }
                                Text { id: txtColorScheme; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Node Color"; font.family: "Ubuntu"; }
                                Text { id: txtNodeColor; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Coloring Seed"; font.family: "Ubuntu"; }
                                Text { id: txtColoringSeed; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}



                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Image Rendering Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Width"; font.family: "Ubuntu"; }
                                Text { id: txtImageWidth; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Height"; font.family: "Ubuntu"; }
                                Text { id: txtImageHeight; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Border Size"; font.family: "Ubuntu"; }
                                Text { id: txtImageBorderSize; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}


                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Graph Image Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Node Size Mode"; font.family: "Ubuntu"; }
                                Text { id: txtImageNodeSizeMode; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Node Size"; font.family: "Ubuntu"; visible: root.nodeSizeMode === 'fixed';}
                                Text { id: txtImageNodeSize; text: ""; font.family: "Open Sans"; visible: root.nodeSizeMode === 'fixed'; }
                                Item {Layout.fillWidth: true; visible: root.nodeSizeMode === 'fixed';}

                                Text { text: "Edge Size"; font.family: "Ubuntu"; visible: root.nodeSizeMode === 'fixed'; }
                                Text { id: txtImageEdgeSize; text: ""; font.family: "Open Sans"; visible: root.nodeSizeMode === 'fixed'; }
                                Item {Layout.fillWidth: true; visible: root.nodeSizeMode === 'fixed';}

                                Text { text: "Minimum Node Size"; font.family: "Ubuntu"; visible: root.nodeSizeMode !== 'fixed'; }
                                Text { id: txtImageMinNodeSize; text: ""; font.family: "Open Sans"; visible: root.nodeSizeMode !== 'fixed'; }
                                Item {Layout.fillWidth: true; visible: root.nodeSizeMode !== 'fixed';}

                                Text { text: "Maximum Node Size"; font.family: "Ubuntu"; visible: root.nodeSizeMode !== 'fixed';  }
                                Text { id: txtImageMaxNodeSize; text: ""; font.family: "Open Sans"; visible: root.nodeSizeMode !== 'fixed';  }
                                Item {Layout.fillWidth: true; visible: root.nodeSizeMode !== 'fixed'; }

                                Text { text: "Label Node Type"; font.family: "Ubuntu"; }
                                Text { id: txtImageLableNodeType; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Label Size"; font.family: "Ubuntu"; }
                                Text { id: txtImageLabelSize; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Node Shadow Color"; font.family: "Ubuntu"; visible: root.nodeSizeMode === 'highlight-new' && false; }
                                Text { id: txtImageNodeShadowColor; text: ""; font.family: "Open Sans"; visible: root.nodeSizeMode === 'highlight-new' && false; }
                                Item {Layout.fillWidth: true; visible: root.nodeSizeMode === 'highlight-new' && false;}

                                Text { text: "Cut Edge Length"; font.family: "Ubuntu"; visible: root.scheme === 'cut-edges';}
                                Text { id: txtImageCutEdgeLength; text: ""; font.family: "Open Sans"; visible: root.scheme === 'cut-edges'; }
                                Item {Layout.fillWidth: true; visible: root.scheme === 'cut-edges';}

                                Text { text: "Cut Edge Node Size"; font.family: "Ubuntu"; visible: root.scheme === 'cut-edges'; }
                                Text { id: txtImageCutEdgeNodeSize; text: ""; font.family: "Open Sans"; visible: root.scheme === 'cut-edges'; }
                                Item {Layout.fillWidth: true; visible: root.scheme === 'cut-edges';}



                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Video Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Video Path"; font.family: "Ubuntu"; }
                                Text { id: txtVideoPath; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "Video FPS"; font.family: "Ubuntu";}
                                Text { id: txtVideoFPS; text: ""; font.family: "Open Sans"; }
                                Item { Layout.fillWidth: true;}

                                Text { text: "Video Padding Time"; font.family: "Ubuntu";}
                                Text { id: txtVideoPaddingTime; text: ""; font.family: "Open Sans"; }
                                Item { Layout.fillWidth: true;}


                                Item {Layout.preferredWidth: 5; Layout.preferredHeight: 5}
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "PDF Properties"; font.family: "Ubuntu"; font.bold: true }
                                Item { Layout.preferredWidth: 5 }
                                Item {Layout.fillWidth: true}

                                Text { text: "Generating PDF"; font.family: "Ubuntu"; }
                                Text { id: txtGeneratingPDF; text: ""; font.family: "Open Sans" }
                                Item {Layout.fillWidth: true}

                                Text { text: "PDF Frame Percentage"; font.family: "Ubuntu"; visible: txtGeneratingPDF.text === "Yes"}
                                Text { id: txtPDFFramePercentage; text: ""; font.family: "Open Sans"; visible: txtGeneratingPDF.text === "Yes"}
                                Item { Layout.fillWidth: true; visible: txtGeneratingPDF.text === "Yes"}


                                Connections {
                                    target: simulationParams
                                    onNotifySchemeChanged: {
                                        txtScheme.text = scheme
                                        root.scheme = scheme
                                    }
                                    onNotifyGraphFilePathChanged: {
                                        txtGraphFilePath.text = graphFilePath
                                        txtGraphFilePath.color = fileExistsAtPath ? "black" : "#E24670"
                                    }
                                    onNotifyGraphFormatChanged: {
                                        txtGraphFormat.text = format
                                    }

                                    onNotifyOutputPathChanged: {
                                        txtOutputFolder.text = outputPath
                                        txtOutputFolder.color = folderExists ? "black" : "#E24670"
                                    }


                                    onNotifyNodeOrderListPathChanged: {
                                        txtNodeOrderListPath.text = orderListPath
                                        txtNodeOrderListPath.color = pathValid ? "black" : "#E24670"
                                    }

                                    onNotifyFilterPathChanged: {
                                        txtFilterPath.text = filterPath
                                        txtFilterPath.color = pathValid ? "black" : "#E24670"
                                    }

                                    onNotifyOrderSeedChanged: {
                                        txtOrderSeed.text = randomSeed
                                        txtOrderSeed.color = isValid ? "black" : "#E24670"
                                    }

                                    onNotifyAssignmentsFilePathChanged: {
                                        txtAssignmentsFilePath.text = assignmentsPath
                                        txtAssignmentsFilePath.color = fileExistsAtPath ? "black" : "#E24670"
                                    }
                                    onNotifyPartitionSeedChanged: {
                                        txtPartitionSeed.text = randomSeed
                                        txtPartitionSeed.color = isValid ? "black" : "#E24670"
                                    }
                                    onNotifyAssignmentModeChanged: {
                                        txtAssignmentsMode.text = assignmentsMode
                                        root.assignmentsMode = assignmentsMode
                                    }
                                    onNotifyNumPartitionsChanged: {
                                        txtNumPartitions.text = numPartitions
                                    }
                                    onNotifyLoadImbalanceChanged: {
                                        txtLoadImbalance.text = loadImbalance
                                    }
                                    onNotifyPartitionWeights: {
                                        txtPartitionWeights.text = partitionWeights
                                        txtPartitionWeights.color = isValid ? "black" : "#E24670"
                                    }
                                    onNotifyVisiblePartitionsChanged: {
                                        txtVisiblePartitions.text = visiblePartitions
                                        txtVisiblePartitions.color = isValid ? "black" : "#E24670"
                                    }






                                    onNotifyClusteringChanged: {
                                        txtClusteringMode.text = clustering
                                        root.clusterMode = clustering
                                    }

                                    onNotifyClusterSeedChanged: {
                                        txtClusteringSeed.text = randomSeed
                                        txtClusteringSeed.color = isValid ? "black" : "#E24670"
                                    }

                                    onNotifyInfomapCallsChanged: {
                                        txtInfomapCalls.text = infomapCalls
                                    }

                                    onNotifyGraphLayoutChanged: {
                                        txtGraphLayout.text = graphLayout
                                    }
                                    onNotifyLayoutLinlogForceChanged: {
                                        txtLayoutLinlogForce.text = linlogForce
                                    }
                                    onNotifyLayoutAttractionChanged: {
                                        txtLayoutAttraction.text = attraction
                                    }
                                    onNotifyLayoutRepulsionChanged: {
                                        txtLayoutRepulsion.text = repulsion
                                    }
                                    onNotifyLayoutRandomSeedChanged: {
                                        txtLayoutSeed.text = randomSeed
                                        txtLayoutSeed.color = isValid ? "black" : "#E24670"
                                    }

                                    onNotifyColorSchemeChanged: {
                                        txtColorScheme.text = colorScheme
                                    }
                                    onNotifyNodeColorChanged: {
                                        txtNodeColor.text = nodeColor
                                        txtNodeColor.color = colorValid ? "black" : "#E24670"
                                    }

                                    onNotifyImageCutEdgeLengthChanged: {
                                        txtImageCutEdgeLength.text = cutEdgeLength
                                    }

                                    onNotifyImageCutEdgeNodeSizeChanged: {
                                        txtImageCutEdgeNodeSize.text = cutEdgeNodeSize
                                    }

                                    onNotifyImageBorderSizeChanged: {
                                        txtImageBorderSize.text = borderSize
                                    }
                                    onNotifyImageWidthChanged: {
                                        txtImageWidth.text = width
                                        txtImageWidth.color = isValid ? "black" : "#E24670"
                                    }
                                    onNotifyImageHeightChanged: {
                                        txtImageHeight.text = height
                                        txtImageHeight.color = isValid ? "black" : "#E24670"
                                    }

                                    onNotifyImageNodeSizeModeChanged: {
                                        txtImageNodeSizeMode.text = nodeSizeMode
                                        root.nodeSizeMode = nodeSizeMode
                                    }

                                    onNotifyImageNodeSizeChanged: {
                                        txtImageNodeSize.text = nodeSize
                                    }

                                    onNotifyImageMinNodeSizeChanged: {
                                        txtImageMinNodeSize.text = minNodeSize
                                    }

                                    onNotifyImageMaxNodeSizeChanged: {
                                        txtImageMaxNodeSize.text = maxNodeSize
                                    }

                                    onNotifyImageEdgeSizeChanged: {
                                        txtImageEdgeSize.text = edgeSize
                                    }

                                    onNotifyImageLabelSizeChanged: {
                                        txtImageLabelSize.text = labelSize
                                    }

                                    onNotifyImageLabelTypeChanged: {
                                        txtImageLableNodeType.text = labelType
                                    }

                                    onNotifyNodeShadowColorChanged: {
                                        txtImageNodeShadowColor.text = nodeShadowColor
                                    }

                                    onNotifyColoringRandomSeedChanged: {
                                        txtColoringSeed.text = randomSeed
                                        txtColoringSeed.color = isValid ? "black" : "#E24670"
                                    }

                                    onNotifyVideoFullPathChanged: {
                                        txtVideoPath.text = videoFullPath
                                        txtVideoPath.color = isValid ? "black" : "#E24670"
                                    }
                                    onNotifyVideoFPSChanged: {
                                        txtVideoFPS.text = fps
                                    }

                                    onNotifyVideoPaddingTimeChanged: {
                                        txtVideoPaddingTime.text = paddingTime
                                    }

                                    onNotifyPDFEnabledChanged: {
                                        txtGeneratingPDF.text = enabled ? "Yes" : "No"
                                    }
                                    onNotifyPDFFramePercentageChanged: {
                                        txtPDFFramePercentage.text = pdfFramePercentage
                                    }

                                }
                            }
                        }
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

    Item {
        id: paneProgramOutput

        anchors.left: root.left
        anchors.right: root.right

        //anchors.top: paneDetails.bottom

        //height: childrenRect.height
        anchors.bottom: paneControls.top

        height: childrenRect.height

        //visible: false

        //visible: !paneDetails.visible

        ColumnLayout {
            width: parent.width
            //anchors.fill: parent

            Rectangle {
                radius: 5
                color: "#F7F7F7"

                Layout.fillWidth: true
                //Layout.fillHeight: true
                Layout.margins: 10
                Layout.preferredHeight: childrenRect.height

                ColumnLayout {
                    //anchors.fill: parent
                    width: parent.width

                    // contents go here
                    Text {
                        id: txtoutput
                        text: "DGS Graphstream Output: <i>the most recent output is at the top</i>"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtoutput.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    Item {
                        Layout.preferredHeight: 240
                        Layout.fillWidth: true

                        ListView {
                            id: outputLV
                            clip: true

                            anchors.fill: parent
                            anchors.margins: 5

                            property bool scrollActive: true

                            ScrollBar.vertical: ScrollBar {
                                id: lvSB
                                active: outputLV.scrollActive
                                onActiveChanged: {
                                    if (lvSB.active !== outputLV.scrollActive) {
                                        lvSB.active = outputLV.scrollActive
                                    }
                                }
                             }

                            model: ListModel {
                                id: outputLM
                            }

                            delegate: Item {
                                id: delegateOutput

                                width: outputLV.width

                                height: txtOutputLine.paintedHeight + 4

                                TextEdit {
                                    id: txtOutputLine
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.leftMargin: 5

                                    font.family: "Open Sans"
                                    font.pixelSize: 12

                                    readOnly: true
                                    selectByMouse: true
                                    textFormat: Text.RichText

                                    text: '<b>' + timestamp + '</b>: ' + outputLine
                                    width: outputLV.width
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    }


    Item {
        id: paneControls

        anchors.left: root.left
        anchors.right: root.right

        anchors.bottom: root.bottom

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
                        id: txtControls
                        text: "Controls"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtControls.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    RowLayout {
                        Item {Layout.fillWidth: true}

                        Text {
                            id: txtNumErrors
                            property int errors: 0
                            text: "There " + (txtNumErrors.errors === 1 ? "is " : "are ") + + String(txtNumErrors.errors) + " error" + (txtNumErrors.errors === 1 ? "" : "s") + " in the chosen parameters."

                            visible: txtNumErrors.errors > 0
                            color: "#E24670"
                            font.family: "Open Sans"

                            Connections {
                                target: dgsGraphstream
                                onNotifyErrorCount: {
                                    txtNumErrors.errors = errors
                                }
                            }
                        }

                        Item {width: 1}

                        BasicComponents.Busyindicator {
                            id: busyIndicator
                            running: btnStart.isRunning
                            Layout.preferredHeight: 25
                            Layout.preferredWidth: 25
                        }

                        BasicComponents.Button {
                            id:btnStart
                            text: "Start"

                            property bool isRunning: false

                            enabled: btnStart.isRunning === false && txtNumErrors.errors === 0

                            onClicked: {
                                if (paneProgramOutput.visible === true) {
                                    dgsGraphstream.run()
                                    outputLM.clear()
                                }
                            }

                            Connections {
                                target: dgsGraphstream

                                onNotifyRunnerStarted: {
                                    btnStart.isRunning = true
                                }
                                onNotifyRunnerFinished: {
                                    btnStart.isRunning = false
                                }
                                onNotifyOutputAvailable: {
                                    outputLM.insert(0, {"timestamp":timestamp,"outputLine":output})
                                }
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            text: "Cancel"

                            enabled: btnStart.isRunning === true

                            onClicked: {
                                dgsGraphstream.stop()
                            }
                        }

                        Item {Layout.preferredWidth: 5}

                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

}
