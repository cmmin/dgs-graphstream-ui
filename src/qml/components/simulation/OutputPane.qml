import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

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

                            //text: "../../dgs-graphstream/output/"

                            property bool disableUpdate: false
                            enabled: false

                            background: Rectangle {
                                color: "white"
                                border.color: "#BFBFBF"
                                border.width: 1
                            }

                            onTextChanged: {
                                if(txtOutputFolderPath.disableUpdate === false) {
                                    simulationParams.slotSetOutputPath(txtOutputFolderPath.text)
                                }
                            }

                            Connections {
                                target: simulationParams
                                onNotifyOutputPathChanged: {
                                    txtOutputFolderPath.pathValid = folderExists
                                    if(txtOutputFolderPath.text !== outputPath) {
                                        txtOutputFolderPath.disableUpdate = true
                                        txtOutputFolderPath.text = outputPath
                                        txtOutputFolderPath.disableUpdate = false
                                    }
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
                                if(outputPath.length === 0) {
                                    outputPath = 'output folder is required'
                                }
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
                            text: "Video File Name"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        TextField {
                            id: txtVideoPath
                            Layout.preferredWidth: 300
                            property bool pathValid: true

                            color: txtVideoPath.pathValid ? "black" : "#E24670"

                            text: "vid"

                            background: Rectangle {
                                color: "white"
                                border.color: "#BFBFBF"
                                border.width: 1
                            }

                            onTextChanged: {
                                simulationParams.slotSetVideoPath(txtVideoPath.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyVideoPathChanged: {
                                    txtVideoPath.pathValid = true
                                    if(txtVideoPath.text !== videoPath) {
                                        txtVideoPath.text = videoPath
                                    }
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

                            Connections {
                                target: simulationParams
                                onNotifyVideoFPSChanged: {
                                    if(sldrFPS.value !== fps) {
                                        sldrFPS.value = fps
                                    }
                                }
                            }

                        }

                        Text {
                            id: txtFPS
                            text: "8 FPS"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyVideoFPSChanged: {
                                    txtFPS.text = String(fps) + " FPS"
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

                            Connections {
                                target: simulationParams
                                onNotifyVideoPaddingTimeChanged: {
                                    if(sldrPaddingTime.value !== paddingTime) {
                                        sldrPaddingTime.value = paddingTime
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtPaddingTime
                            text: "2.0s"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            Connections {
                                target: simulationParams
                                onNotifyVideoPaddingTimeChanged: {
                                    txtPaddingTime.text = String(paddingTime) + "s"
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipPaddingTime')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
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

                            Connections {
                                target: simulationParams
                                onNotifyPDFEnabledChanged: {
                                    chbxPDFEnabled.checked = enabled
                                }
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

                            Connections {
                                target: simulationParams
                                onNotifyPDFFramePercentageChanged: {
                                    if(sldrPDFFramePercentage.value !== pdfFramePercentage) {
                                        sldrPDFFramePercentage.value = pdfFramePercentage
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtPDFFramePercentage
                            text: "20%"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15

                            color: chbxPDFEnabled.checked ? "black" : "#858585"

                            Connections {
                                target: simulationParams
                                onNotifyPDFFramePercentageChanged: {
                                    txtPDFFramePercentage.text = String(pdfFramePercentage) + "%"
                                }
                            }
                        }

                        BasicComponents.TooltipIcon {
                            text: uiTexts.get('tooltipFrameConversion')
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                        }

                        Item {Layout.fillWidth: true}
                    }

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE

}
