import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2

import "./basic" as BasicComponents

Item {
    id: root

    property bool projectLoaded: false

    property string existingProjectOutputPath: ''
    property string newProjectOutputPath: ''

    signal createNewProject(string path, string exampleID)
    signal openProject(string path)


    function reset() {
      chbxLoadProject.checked = false
      chbxNewProject.checked = false
      root.existingProjectOutputPath = ''
      root.newProjectOutputPath = ''
      txtOutputValid.checkValid()
      txtNewOutputValid.checkValid()
      cmbCreate.currentIndex = 0
      cmbCreate.creatingEmpty = true
    }

    Component.onCompleted: {
        //root.openProject('/Users/voreno/Desktop/tt')
    }

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

    ButtonGroup {
        id: chckGroup
        //exclusive: true
    }

    RowLayout {
        id: rwPickOpenNew
        anchors.left: root.left
        anchors.right: root.right
        anchors.top: txtDescription.bottom
        anchors.topMargin: 50

        Item {Layout.fillWidth: true}

        Text {
            text: "Create New Project"

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        BasicComponents.Checkbox {
            id: chbxNewProject
            ButtonGroup.group: chckGroup
        }

        Item {Layout.fillWidth: true}

        Item {Layout.fillWidth: true}

        Text {
            text: "Load Existing Project"

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        BasicComponents.Checkbox {
            id: chbxLoadProject
            ButtonGroup.group: chckGroup
        }

        Item {Layout.fillWidth: true}
    }

    Rectangle {
        id: newProjectPanel

        color: "#F7F7F7"

        radius: 3

        visible: chbxNewProject.checked
        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: rwPickOpenNew.bottom
        anchors.right: root.right

        anchors.margins: 20

        Text {
            id: txtCreateProject
            text: "Step 1: Pick a folder for the project"

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        RowLayout {
            id: rwCreateOutputPath
            anchors.top: txtCreateProject.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                text: "Pick Folder"
            }

            BasicComponents.Button {
                text: "Choose..."

                width: 100

                onClicked: {
                    folderDialog.callerID = "new"
                    folderDialog.open()
                }
            }

            Text {
                text: root.newProjectOutputPath
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true

                onTextChanged: {
                    txtNewOutputValid.checkValid()
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
                color: txtNewOutputValid.isValid ? "#009E6A" : "#E24670"

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


        Text {
            id: txtCreateStep2
            text: "Step 2: Create new project or use example project"

            anchors.top: rwOutputExists.bottom
            anchors.left: parent.left
            anchors.margins: 10

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        BasicComponents.Combo {
            id: cmbCreate

            anchors.left: parent.left
            anchors.top: txtCreateStep2.bottom
            anchors.margins: 10

            property bool creatingEmpty: true

            width: 150

            model: ["New Project", "Example Project"]

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

            visible: cmbCreate.creatingEmpty === false

            text: "Step 3: Choose the example"

            anchors.top: cmbCreate.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            wrapMode: Text.WordWrap

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        RowLayout {
            id: rwCreateExampleCmb
            anchors.top: txtCreateDescription.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            visible: cmbCreate.creatingEmpty === false

            Text {
                text: "Example:"
            }

            BasicComponents.Combo {
                id: cmbExample

                Layout.preferredWidth: 350

                property string exampleID: ''
                property string exampleDescription: ''
                property string examplePath: ''

                onExampleIDChanged: {
                    cmbExample.exampleDescription = examples.exampleDescription(cmbExample.exampleID)
                    cmbExample.examplePath = examples.examplePath(cmbExample.exampleID)
                }

                width: 350

                model: []
                property var modelExampleKey: []

                onActivated: {
                    cmbExample.exampleID = cmbExample.modelExampleKey[index]
                    cmbExample.exampleDescription = examples.exampleDescription(cmbExample.exampleID)
                }

                Component.onCompleted: {
                    cmbExample.modelExampleKey = examples.examples()

                    var m = []

                    for(var i = 0; i < cmbExample.modelExampleKey.length; i++) {
                        if (i === 0) {
                            cmbExample.exampleID = cmbExample.modelExampleKey[i]
                        }
                        m.push(examples.exampleTitle(cmbExample.modelExampleKey[i]))
                    }
                    cmbExample.model = m
                }
            }

            Item {Layout.fillWidth: true}
        }

        RowLayout {
            id: rwDescr
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
            anchors.top: rwDescr.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20

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

            Item {Layout.fillWidth: true}

        }
    }

    Rectangle {
        id: openProjectPanel

        color: "#F7F7F7"

        radius: 3

        visible: chbxLoadProject.checked

        anchors.left: root.left
        anchors.bottom: root.bottom
        anchors.top: rwPickOpenNew.bottom
        anchors.right: root.right

        anchors.margins: 20

        Text {
            id: txtOpenProject
            text: "Step 1: Locate the project's folder"

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10

            font.family: "Ubuntu"
            font.pixelSize: 18
        }

        RowLayout {
            id: rwOpenOutputPath
            anchors.top: txtOpenProject.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            Text {
                text: "Project Folder"
            }

            BasicComponents.Button {
                text: "Choose..."

                width: 100

                onClicked: {
                    folderDialog.callerID = "existing"
                    folderDialog.open()
                }
            }

            Text {
                text: root.existingProjectOutputPath
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true

                onTextChanged: {
                    txtOutputValid.checkValid()
                }
            }
        }

        RowLayout {
            id: rwProjectPath
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

                color: txtOutputValid.isValid ? "#009E6A" : "#E24670"

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
            anchors.top: rwProjectPath.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            BasicComponents.Button {
                text: "Open Project"
                Layout.preferredWidth: 150

                enabled: txtOutputValid.isValid

                onClicked: {
                    root.openProject(root.existingProjectOutputPath)
                }
            }

            Item {Layout.fillWidth: true}
        }
    }

}
