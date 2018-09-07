import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3

import "./basic" as BasicComponents

Item {
    id: root

    property bool projectLoaded: false

    property string existingProjectOutputPath: ''
    property string newProjectOutputPath: ''

    signal createNewProject(string path, string exampleID)
    signal openProject(string path)

    /*Component.onCompleted: {
        root.openProject('/Users/voreno/Desktop/tt')
    }*/

    FileDialog {
        id: folderDialog

        title: "Please choose a folder"
        folder: shortcuts.home

        selectFolder: true
        selectMultiple: false

        property string callerID: ''

        onAccepted: {
            if (folderDialog.fileUrls.length > 0) {
                var path = qmlUtils.parseSystemPath(folderDialog.fileUrls[0])
                folderDialog.folder = path

                if(folderDialog.callerID === 'new') {
                    root.newProjectOutputPath = path
                }
                if(folderDialog.callerID === 'existing') {
                    root.existingProjectOutputPath = path
                }
            }
        }
    }

    Text {
        id: txtTitle
        text: "Welcome to DGS Graphstream"
        anchors.top: root.top
        anchors.topMargin: 20
        //anchors.left: root.left

        font.family: "Ubuntu"
        font.pixelSize: 18

        anchors.horizontalCenter: root.horizontalCenter
    }

    Text {
        id: txtDescription
        text: "Please open an existing project or create a new one."

        font.family: "Open Sans"
        font.pixelSize: 12

        wrapMode: Text.WordWrap

        anchors.top: txtTitle.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: root.horizontalCenter
    }


    Rectangle {
        id: rectSeparator

        anchors.top: txtDescription.bottom
        anchors.bottom: root.bottom

        anchors.topMargin: 60
        anchors.bottomMargin: 60

        width: 1

        color: "#BFBFBF"

        anchors.horizontalCenter: root.horizontalCenter

    }

    Item {
        id: newProjectPanel


        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: txtDescription.bottom
        anchors.right: rectSeparator.left

        anchors.margins: 20

        Text {
            id: txtCreateProject
            text: "Create Project"

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10

            font.family: "Ubuntu"
            font.pixelSize: 18
        }


        BasicComponents.Combo {
            id: cmbCreate

            anchors.left: parent.left
            anchors.top: txtCreateProject.bottom
            anchors.margins: 10

            property bool creatingEmpty: true

            width: 150

            model: ["Empty Project", "From Example"]

            onActivated: {
                if(index === 0) {
                    cmbCreate.creatingEmpty = true
                }
                if(index === 1) {
                    cmbCreate.creatingEmpty = false
                }
            }
        }

        Text {
            id: txtCreateDescription

            text: cmbCreate.creatingEmpty ? "Creating new empty project, please select output path." : "Creating new project from examples, please select output path."

            anchors.top: cmbCreate.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            wrapMode: Text.WordWrap

            font.family: "Open Sans"
            font.pixelSize: 14
        }

        RowLayout {
            id: rwCreateOutputPath
            anchors.top: txtCreateDescription.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                text: "Output Path:"
            }

            Text {
                text: root.newProjectOutputPath
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true

                onTextChanged: {
                    txtNewOutputValid.checkValid()
                }
            }

            BasicComponents.Button {
                text: "Choose..."

                width: 100

                onClicked: {
                    folderDialog.callerID = "new"
                    folderDialog.open()
                }
            }
        }

        RowLayout {
            id: rwOutputExists
            anchors.top: rwCreateOutputPath.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            visible: root.newProjectOutputPath.length > 0

            Text {
                id: txtNewOutputValid

                property bool isValid: false

                function checkValid() {
                    txtNewOutputValid.isValid = qmlUtils.checkNewProjectFolderValid(root.newProjectOutputPath)
                }

                text: {
                    if(txtNewOutputValid.isValid) {
                        return "Project folder is valid, folder is empty."
                    }
                    else {
                        return "Error, chosen project folder is not empty."
                    }
                }

                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            id: rwCreateExampleCmb
            anchors.top: rwOutputExists.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            visible: cmbCreate.creatingEmpty === false

            Text {
                text: "Example:"
            }

            BasicComponents.Combo {
                id: cmbExample

                Layout.preferredWidth: 150

                property string exampleID: 'ex1'
                property string exampleDescription: "Description for example " + cmbExample.exampleID

                onExampleIDChanged: {
                    cmbExample.exampleDescription = "Description for example " + cmbExample.exampleID
                }

                width: 150

                model: ["Example 1", "Example 2"]

                onActivated: {
                    if(index === 0) {
                        cmbExample.exampleID = 'ex1'
                    }
                    if(index === 1) {
                        cmbExample.exampleID = 'ex2'
                    }
                }
            }

            Item {Layout.fillWidth: true}
        }

        RowLayout {
            anchors.top: rwCreateExampleCmb.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            visible: cmbCreate.creatingEmpty === false

            Text {
                text: cmbExample.exampleDescription
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }


        RowLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20

            Item {Layout.fillWidth: true}

            BasicComponents.Button {
                text: "Create Project"
                Layout.preferredWidth: 150

                enabled: txtNewOutputValid.isValid

                onClicked: {
                    if(cmbCreate.creatingEmpty) {
                        root.createNewProject(root.newProjectOutputPath, '')
                    }
                    else {
                        root.createNewProject(root.newProjectOutputPath, cmbExample.exampleID)
                    }
                }
            }
        }
    }

    Item {
        id: openProjectPanel

        anchors.left: rectSeparator.right
        anchors.bottom: root.bottom
        anchors.top: txtDescription.bottom
        anchors.right: root.right

        anchors.margins: 20

        Text {
            id: txtOpenProject
            text: "Open Existing Project"

            anchors.top: parent.top

            font.family: "Ubuntu"
            font.pixelSize: 18

            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            id: rwOpenOutputPath
            anchors.top: txtOpenProject.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                text: "Output Path:"
            }

            Text {
                text: root.existingProjectOutputPath
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true

                onTextChanged: {
                    txtOutputValid.checkValid()
                }
            }

            BasicComponents.Button {
                text: "Choose..."

                width: 100

                onClicked: {
                    folderDialog.callerID = "existing"
                    folderDialog.open()
                }
            }
        }

        RowLayout {
            anchors.top: rwOpenOutputPath.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            visible: root.existingProjectOutputPath.length > 0

            Text {
                id: txtOutputValid

                property bool isValid: false

                function checkValid() {
                    txtOutputValid.isValid = qmlUtils.checkProjectFolderValid(root.existingProjectOutputPath)
                }

                text: {
                    if(txtOutputValid.isValid) {
                        return "Project folder is valid, settings were located."
                    }
                    else {
                        return "Could not locate a project at the specified folder. Please create a new project instead or change path."
                    }
                }

                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20

            Item {Layout.fillWidth: true}

            BasicComponents.Button {
                text: "Open Project"
                Layout.preferredWidth: 100

                enabled: txtOutputValid.isValid

                onClicked: {
                    root.openProject(root.existingProjectOutputPath)
                }
            }
        }
    }
}
