import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import "./../basic/" as BasicComponents

Item {
    id: root

    property string scheme: ""

    Connections {
        target: simulationParams
        onNotifySchemeChanged: {
            root.scheme = scheme
        }
    }

    Text {
        id: paneTitle
        // Title
        text: "Image Settings"
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
        text: "Settings for the images that are generated for the PDF or Video outputs."
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
        id: paneImage

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
                        text: "Image Properties"
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

                    // width = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Width "
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtWidth
                            Layout.preferredWidth: 100
                            property bool isValid: true

                            text: "1280"

                            color: txtWidth.isValid ? "black" : "#E24670"

                            onTextChanged: {
                                simulationParams.slotSetImageWidth(txtWidth.text)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageWidthChanged: {
                                    txtWidth.isValid = isValid
                                    if(txtWidth.text !== width) {
                                        txtWidth.text = width
                                    }
                                }
                            }
                        }

                        Text {
                            text: "pixels"
                            font.family: "Open Sans"
                        }
                    }

                    // height = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Height"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Textfield {
                            id: txtHeight
                            Layout.preferredWidth: 100
                            property bool isValid: true

                            text: "780"

                            color: txtHeight.isValid ? "black" : "#E24670"

                            onTextChanged: {
                                simulationParams.slotSetImageHeight(txtHeight.text)
                            }


                            Connections {
                                target: simulationParams
                                onNotifyImageHeightChanged: {
                                    txtHeight.isValid = isValid
                                    if(txtHeight.text !== height) {
                                        txtHeight.text = height
                                    }
                                }
                            }
                        }

                        Text {
                            text: "pixels"
                            font.family: "Open Sans"
                        }
                    }

                    // border size = textfield
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Border Size"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                        BasicComponents.Slider {
                            id: sldrBorderSize
                            from: 1
                            to: 5
                            value: 1
                            stepSize: 1

                            Layout.preferredWidth: 100

                            onValueChanged: {
                                simulationParams.slotSetImageBorderSize(sldrBorderSize.value)
                            }

                            Connections {
                                target: simulationParams
                                onNotifyImageBorderSizeChanged: {
                                    if(sldrBorderSize.value !== borderSize) {
                                        sldrBorderSize.value = borderSize
                                    }
                                }
                            }
                        }

                        Text {
                            id: txtBorderSize
                            text: "1 pixel"
                            font.family: "Open Sans"

                            Connections {
                                target: simulationParams
                                onNotifyImageBorderSizeChanged: {
                                    txtBorderSize.text = String(borderSize) + (borderSize == 1 ? " pixel" : " pixels")
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
