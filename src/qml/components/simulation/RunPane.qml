import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

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
        anchors.bottom: paneControls.top

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
                        Layout.fillHeight: true
                        Layout.fillWidth: true

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
                                    }
                                    onNotifyGraphFilePathChanged: {
                                        txtGraphFilePath.text = graphFilePath
                                        txtGraphFilePath.color = fileExistsAtPath ? "black" : "#E24670"
                                    }
                                    onNotifyGraphFormatChanged: {
                                        txtGraphFormat.text = format
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

                        BasicComponents.Button {
                            text: "Start"
                        }

                        Item {Layout.preferredWidth: 5}

                        BasicComponents.Button {
                            text: "Cancel"
                            enabled: false
                        }

                        Item {Layout.preferredWidth: 5}

                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

}
