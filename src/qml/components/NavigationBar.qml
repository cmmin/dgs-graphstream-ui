import QtQuick 2.7
import QtQuick.Layouts 1.3

Rectangle {
    id: root

    height: 40

    property string currentPageTitle: ""
    property string currentPageCode: ""

    property bool settingsActivated: false
    property bool settingsValid: true

    property bool projectLoadedAtLeastOnce: false

    property string currentProjectPath: ""

    property bool wizardVisible: false

    signal openProjectWizard
    signal backFromProjectWizard

    Connections {
        target: dgsSettings
        onNotifyOverallValidationChanged: {
            root.settingsValid = settingsValid
        }
    }

    Connections {
        target: simulationParams
        onNotifyOutputPathChanged: {
            root.currentProjectPath = outputPath
        }
    }

    Component.onCompleted: {
        root.settingsValid = dgsSettings.dgsSettingsValid
    }

    RowLayout {
        anchors.fill: parent

        Item {width:1} // spacer

        // Page Title
        Text {
            id: txtTitle
            text: "Emergency Shelter Reunification Visualizer" + (root.currentProjectPath.length ? ": " + root.currentProjectPath : "") +  (root.settingsValid === true ? "" : " - errors in settings, cannot run")
            font.family: "Ubuntu"
            font.pixelSize: 16
            Layout.alignment: Qt.AlignVCenter
            color: root.settingsValid === true ? "black" : "#E24670"

        }

        Item {Layout.fillWidth: true} // filler spacer

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: txtOpenWizard.paintedWidth + 12

            visible: !root.settingsActivated && !root.wizardVisible

            Text {
                id: txtOpenWizard
                text: "Open Project Wizard"
                font.family: "Ubuntu"
                font.pixelSize: 16
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.openProjectWizard()
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: txtOpenWizard.paintedWidth + 12

            visible: !root.settingsActivated && root.wizardVisible && root.projectLoadedAtLeastOnce

            Text {
                id: txtBackWizard
                text: "Back to Project"
                font.family: "Ubuntu"
                font.pixelSize: 16
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.backFromProjectWizard()
                }
            }
        }


        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 80

            visible: root.settingsActivated

            Text {
                id: txtBack
                text: "Cancel"
                font.family: "Ubuntu"
                font.pixelSize: 16
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.settingsActivated = false
                    dgsSettings.cancelSettingsChanges()
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 80

            visible: root.settingsActivated

            Text {
                id: txtSave
                text: "Save"
                font.family: "Ubuntu"
                font.pixelSize: 16
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#BFBFBF"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.settingsActivated = false
                    dgsSettings.commitSettingsChanges()
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 40

            visible: !root.settingsActivated
            //visible: false

            Image {
                source: "../assets/icons/settings_dark.png"
                width: 24; height: 24
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.settingsActivated = true
                    }
                }
            }
        }

        Item {width:1} // spacer
    }

    Rectangle {
        id: bottomBorderLine
        height: 1
        color: "#BFBFBF"
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
    }
}
