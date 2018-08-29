import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./../basic/" as BasicComponents

Item {
    id: root

    Text {
        id: paneTitle
        // Title
        text: "Output Settings"
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
        text: "The settings in this pane allow to control the full output of the DGS Graphstream program."
        font.family: "Open Sans"
        font.pixelSize: 14

        anchors.left: root.left
        anchors.top: paneTitle.bottom
        anchors.right: root.right

        anchors.leftMargin: 10
        anchors.topMargin: 10

        wrapMode: Text.WordWrap
    }

    // Output Options
    Item {
        id: paneOutput

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
                        id: txtOutput
                        text: "Output Options"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtOutput.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    // input graph
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Output Folder Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        TextField {
                            id: txtOutputFolderPath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtOutputFolderPath.pathValid ? "black" : "#E24670"

                            text: "../../dgs-graphstream/output/"

                            background: Rectangle {
                                color: "white"
                                border.color: "#BFBFBF"
                                border.width: 1
                            }

                            onTextChanged: {
                                simulationParams.slotSetOutputPath(txtOutputFolderPath.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetOutputPath(txtOutputFolderPath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyOutputPathChanged: {
                                    txtOutputFolderPath.pathValid = folderExists
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Text {
                        id: txtFullOutputPath

                        property string path: ""
                        property string errorStr: "<b>Folder Doesn't Exist</b>: "
                        property bool showError: false

                        Layout.leftMargin: 15

                        text: txtFullOutputPath.showError ? txtFullOutputPath.errorStr + txtFullOutputPath.path : txtFullOutputPath.path
                        font.family: "Open Sans"
                        font.pixelSize: 10
                        color: txtFullOutputPath.showError ? "#E24670" : "#858585"

                        Connections {
                            target: simulationParams
                            onNotifyOutputPathChanged: {
                                txtFullOutputPath.path = outputPath
                                txtFullOutputPath.showError = !folderExists
                            }
                        }
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

    // video Options
    Item {
        id: paneVideo

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneOutput.bottom

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
                        id: txtVideo
                        text: "Video Options"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtVideo.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Video File Path"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        TextField {
                            id: txtVideoPath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtVideoPath.pathValid ? "black" : "#E24670"

                            text: "vid.mp4"

                            background: Rectangle {
                                color: "white"
                                border.color: "#BFBFBF"
                                border.width: 1
                            }

                            onTextChanged: {
                                simulationParams.slotSetVideoPath(txtVideoPath.text)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetVideoPath(txtVideoPath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyVideoPathChanged: {
                                    txtVideoPath.pathValid = true
                                }
                            }
                        }

                        Text {
                            id: txtFullVideoPath
                            text : ""
                            property bool pathValid: true

                            color: txtFullVideoPath.pathValid ? "black" : "#E24670"

                            Connections {
                                target: simulationParams
                                onNotifyVideoFullPathChanged: {
                                    txtFullVideoPath.text = videoFullPath
                                    txtFullVideoPath.pathValid = isValid
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // fps
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Frames Per Second (FPS)"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrFPS

                            from: 1
                            to: 60
                            value: 8
                            stepSize: 1

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetVideoFPS(sldrFPS.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetVideoFPS(sldrFPS.value)
                            }
                        }

                        Text {
                            id: txtFPS
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyVideoFPSChanged: {
                                    txtFPS.text = String(fps)
                                }
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // padding time
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Padding Time"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrPaddingTime

                            from: 0.0
                            to: 10.0
                            value: 2.0
                            stepSize: 0.2

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetVideoPaddingTime(sldrPaddingTime.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetVideoPaddingTime(sldrPaddingTime.value)
                            }
                        }

                        Text {
                            id: txtPaddingTime
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyVideoPaddingTimeChanged: {
                                    txtPaddingTime.text = String(paddingTime)
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

    // PDF Options
    Item {
        id: panePDF

        anchors.left: root.left
        anchors.right: root.right

        anchors.top: paneVideo.bottom

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
                        id: txtPDF
                        text: "PDF Options"
                        font.family: "Ubuntu"
                        font.pixelSize: 14
                        Layout.leftMargin: 10
                        Layout.topMargin: 10
                    }

                    Rectangle {
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: txtPDF.paintedWidth * 2
                        Layout.leftMargin: 10
                        //Layout.rightMargin: 100
                        color: "#BFBFBF"
                    }

                    Item {Layout.preferredHeight: 5}

                    RowLayout {
                        Text {
                            text: "Enable PDF Output"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Checkbox {
                            id: chbxPDFEnabled
                            onCheckedChanged: {
                                simulationParams.slotSetPDFEnabled(chbxPDFEnabled.checked)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetPDFEnabled(chbxPDFEnabled.checked)
                            }
                        }

                        Item {Layout.fillWidth: true}
                    }

                    // pdf frame percentage
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Frame Conversion Percentage"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxPDFEnabled.checked ? "black" : "#858585"

                        }

                        BasicComponents.Slider {
                            id: sldrPDFFramePercentage

                            from: 0
                            to: 100
                            value: 20
                            stepSize: 1

                            enabled: chbxPDFEnabled.checked

                            Layout.preferredWidth: 200

                            onValueChanged: {
                                simulationParams.slotSetPDFFramePercentage(sldrPDFFramePercentage.value)
                            }

                            Component.onCompleted: {
                                simulationParams.slotSetPDFFramePercentage(sldrPDFFramePercentage.value)
                            }

                        }

                        Text {
                            id: txtPDFFramePercentage
                            text: ""
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxPDFEnabled.checked ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyPDFFramePercentageChanged: {
                                    txtPDFFramePercentage.text = String(pdfFramePercentage)
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
