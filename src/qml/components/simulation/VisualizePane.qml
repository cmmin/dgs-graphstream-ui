import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

import "./../basic/" as BasicComponents

Item {
    id: root

    Text {
        id: paneTitle
        // Title
        text: "Simulation Visualization Settings & Parameters"
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
        text: "Pick the visualization mode for the simulation."
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
                        text: "Visualization Mode"
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
                        Layout.fillWidth: true

                        Text {
                            text: "Mode"
                            font.family: "Open Sans"
                            Layout.leftMargin: 15
                        }

                      BasicComponents.Combo {
                          id: cmbxScheme
                          model: ["showcase communities", "showcase edges cut"]

                          Layout.preferredWidth: 300
                          //Layout.leftMargin: 15

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

                    Item {Layout.preferredHeight: 10}
                }
            }
        }
    } // END PANE
}
