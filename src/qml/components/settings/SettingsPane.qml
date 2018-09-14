import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "./../basic" as BasicComponents

Item {
    id: root

    // programs that are required
    /*

    DGS Graphstream Program
    config.ini -> oslom2; infomap; gvmap

    montage
    ffmpeg

    */

    function dgsProgramDirectoryChanged(path) {
        dgsSettings.slotSetDGSProgramDirectory(path)
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a folder"
        folder: shortcuts.home
        selectFolder: true
        selectMultiple: false
        property string caller: ''
        onAccepted: {
            if(fileDialog.caller === 'dgs') {
                root.dgsProgramDirectoryChanged(fileDialog.fileUrls)
            }
            if(fileDialog.caller === 'oslom2') {
                dgsSettings.slotSetOslom2ProgramDirectory(fileDialog.fileUrls)
            }
            if(fileDialog.caller === 'infomap') {
                dgsSettings.slotSetInfomapProgramDirectory(fileDialog.fileUrls)
            }
            if(fileDialog.caller === 'gvmap') {
                dgsSettings.slotSetGvmapProgramDirectory(fileDialog.fileUrls)
            }
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 5

        columns: 5

        // DGS Program Directory
        Text { text: "DGS Graphstream Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtGraphstreamDirectory
            Layout.preferredWidth: 300
            onTextChanged: {
                root.dgsProgramDirectoryChanged(txtGraphstreamDirectory.text)
            }
            Connections {
                target: dgsSettings
                onNotifyDGSProgramDirectoryChanged: {
                    txtGraphstreamDirectory.text = dgsDirectoryPath
                    txtDGSProgramDirectoryValid.valid = isValid
                }
            }
            Component.onCompleted: {
                txtGraphstreamDirectory.text = dgsSettings.dgsProgramDirectory
            }
        }
        Item {Layout.fillWidth: true;}
        BasicComponents.Button {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 30
            text: "Locate"

            onClicked: {
                fileDialog.open()
                fileDialog.caller = 'dgs'
            }
        }
        Text {
            id: txtDGSProgramDirectoryValid
            text: txtDGSProgramDirectoryValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtDGSProgramDirectoryValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtDGSProgramDirectoryValid.valid = dgsSettings.dgsProgramDirectoryValid
            }
        }
        // END DGS Program Directory


        // DGS Program Path
        Text { text: "DGS Graphstream Program"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            id: lblDGSProgramPath
            text: ""; font.family: "Ubuntu"; font.pixelSize: 12;
            Connections {
                target: dgsSettings
                onNotifyDGSProgramPathChanged: {
                    lblDGSProgramPath.text = dgsProgramPath
                    txtDGSProgramPathValid.valid = isValid
                }
            }

            Component.onCompleted: {
                lblDGSProgramPath.text = dgsSettings.dgsProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtDGSProgramPathValid
            text: txtDGSProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtDGSProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtDGSProgramPathValid.valid = dgsSettings.dgsProgramPathValid
            }
        }
        // END DGS Program Path


        // Oslom2 Program Directory
        Text { text: "OSLOM2 Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtOslom2Dir
            Layout.preferredWidth: 300
            onTextChanged: {
                dgsSettings.slotSetOslom2ProgramDirectory(txtOslom2Dir.text)
            }
            Connections {
                target: dgsSettings
                onNotifyOslom2ProgramDirectoryChanged: {
                    txtOslom2Dir.text = oslom2DirectoryPath
                    txtOslom2ProgramDirectoryValid.valid = isValid
                }
            }
            Component.onCompleted: {
                txtOslom2Dir.text = dgsSettings.oslom2ProgramDirectory
            }
        }
        Item {Layout.fillWidth: true;}
        BasicComponents.Button {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 30
            text: "Locate"

            onClicked: {
                fileDialog.open()
                fileDialog.caller = 'oslom2'
            }
        }
        Text {
            id: txtOslom2ProgramDirectoryValid
            text: txtOslom2ProgramDirectoryValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtOslom2ProgramDirectoryValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtOslom2ProgramDirectoryValid.valid = dgsSettings.oslom2ProgramDirectoryValid
            }
        }
        // END Oslom2

        // Oslom2 Program Path
        Text { text: "OSLOM2 Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            id: lblOslom2ProgramPath
            text: ""; font.family: "Ubuntu"; font.pixelSize: 12;
            Connections {
                target: dgsSettings
                onNotifyOslom2ProgramPathChanged: {
                    lblOslom2ProgramPath.text = oslom2ProgramPath
                    txtOslom2ProgramPathValid.valid = isValid
                }
            }

            Component.onCompleted: {
                lblOslom2ProgramPath.text = dgsSettings.oslom2ProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtOslom2ProgramPathValid
            text: txtOslom2ProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtOslom2ProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtOslom2ProgramPathValid.valid = dgsSettings.oslom2ProgramPathValid
            }
        }
        // END Oslom2 Program Path


        // Infomap Program Directory
        Text { text: "Infomap Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtInfomapDir
            Layout.preferredWidth: 300
            onTextChanged: {
                dgsSettings.slotSetInfomapProgramDirectory(txtInfomapDir.text)
            }
            Connections {
                target: dgsSettings
                onNotifyInfomapProgramDirectoryChanged: {
                    txtInfomapDir.text = infomapDirectoryPath
                    txtInfomapProgramDirectoryValid.valid = isValid
                }
            }
            Component.onCompleted: {
                txtInfomapDir.text = dgsSettings.infomapProgramDirectory
            }
        }
        Item {Layout.fillWidth: true;}
        BasicComponents.Button {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 30
            text: "Locate"

            onClicked: {
                fileDialog.open()
                fileDialog.caller = 'infomap'
            }
        }
        Text {
            id: txtInfomapProgramDirectoryValid
            text: txtInfomapProgramDirectoryValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtInfomapProgramDirectoryValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtInfomapProgramDirectoryValid.valid = dgsSettings.infomapProgramDirectoryValid
            }
        }
        // END Infomap

        // Infomap Program Path
        Text { text: "Infomap Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            id: lblInfomapProgramPath
            text: ""; font.family: "Ubuntu"; font.pixelSize: 12;
            Connections {
                target: dgsSettings
                onNotifyInfomapProgramPathChanged: {
                    lblInfomapProgramPath.text = infomapProgramPath
                    txtInfomapProgramPathValid.valid = isValid
                }
            }

            Component.onCompleted: {
                lblInfomapProgramPath.text = dgsSettings.infomapProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtInfomapProgramPathValid
            text: txtInfomapProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtInfomapProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtInfomapProgramPathValid.valid = dgsSettings.infomapProgramPathValid
            }
        }
        // END Infomap Program Path


        // Gvmap Program Directory
        Text { text: "Gvmap Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtGvmapDir
            Layout.preferredWidth: 300
            onTextChanged: {
                dgsSettings.slotSetGvmapProgramDirectory(txtGvmapDir.text)
            }
            Connections {
                target: dgsSettings
                onNotifyGvmapProgramDirectoryChanged: {
                    txtGvmapDir.text = gvmapDirectoryPath
                    txtGvmapProgramDirectoryValid.valid = isValid
                }
            }
            Component.onCompleted: {
                txtGvmapDir.text = dgsSettings.gvmapProgramDirectory
            }
        }
        Item {Layout.fillWidth: true;}
        BasicComponents.Button {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 30
            text: "Locate"

            onClicked: {
                fileDialog.open()
                fileDialog.caller = 'gvmap'
            }
        }
        Text {
            id: txtGvmapProgramDirectoryValid
            text: txtGvmapProgramDirectoryValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtGvmapProgramDirectoryValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtGvmapProgramDirectoryValid.valid = dgsSettings.gvmapProgramDirectoryValid
            }
        }
        // END Gvmap

        // Gvmap Program Path
        Text { text: "Gvmap Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            id: lblGvmapProgramPath
            text: ""; font.family: "Ubuntu"; font.pixelSize: 12;
            Connections {
                target: dgsSettings
                onNotifyGvmapProgramPathChanged: {
                    lblGvmapProgramPath.text = gvmapProgramPath
                    txtGvmapProgramPathValid.valid = isValid
                }
            }

            Component.onCompleted: {
                lblGvmapProgramPath.text = dgsSettings.gvmapProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtGvmapProgramPathValid
            text: txtGvmapProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtGvmapProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtGvmapProgramPathValid.valid = dgsSettings.gvmapProgramPathValid
            }
        }
        // END Gvmap Program Path

        // Montage Program
        Text { text: "Montage Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }

        BasicComponents.Textfield {
            id: txtMontageProgramPath
            Layout.preferredWidth: 300

            onTextChanged: {
                dgsSettings.slotSetMontagePath(txtMontageProgramPath.text)
            }

            Connections {
                target: dgsSettings
                onNotifyMontageProgramPathChanged: {
                    txtMontageProgramPathValid.valid = exists
                }
            }

            Component.onCompleted: {
                txtMontageProgramPath.text = dgsSettings.montageProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtMontageProgramPathValid
            text: txtMontageProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtMontageProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtMontageProgramPathValid.valid = dgsSettings.montageProgramPathValid
            }
        }
        // END Montage Program

        // Ffmpeg Program
        Text { text: "Ffmpeg Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }

        BasicComponents.Textfield {
            id: txtFfmpegProgramPath
            Layout.preferredWidth: 300

            onTextChanged: {
                dgsSettings.slotSetFfmpegPath(txtFfmpegProgramPath.text)
            }

            Connections {
                target: dgsSettings
                onNotifyFfmpegProgramPathChanged: {
                    txtFfmpegProgramPathValid.valid = exists
                }
            }

            Component.onCompleted: {
                txtFfmpegProgramPath.text = dgsSettings.ffmpegProgramPath
            }
        }
        Item {Layout.fillWidth: true;}
        Item {width: 1}
        Text {
            id: txtFfmpegProgramPathValid
            text: txtFfmpegProgramPathValid.valid ? "Ok" : "Invalid";
            font.family: "Ubuntu"; font.pixelSize: 12;
            property bool valid: true
            color: txtFfmpegProgramPathValid.valid ? "#009E6A" : "#E24670"
            Component.onCompleted: {
                txtFfmpegProgramPathValid.valid = dgsSettings.ffmpegProgramPathValid
            }
        }
        // END Ffmpeg Program


        /*
        // config.ini
        Text { text: "Update DGS config.ini"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {width: 1}
        Item {Layout.fillWidth: true;}

        BasicComponents.Button {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 30
            text: "Update"

            onClicked: {
                dgsSettings.updateConfigIni()
            }
        }
        Item {width: 1}
        // END config.ini
        */

        // python modules
        Text { text: "<b>networkx</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageNetworkxInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // nxmetis
        Text { text: "<b>nxmetis</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageNxmetisInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // configparser
        Text { text: "<b>configparser</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageConfigparserInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // pydot
        Text { text: "<b>pydot</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packagePydotInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // scipy
        Text { text: "<b>scipy</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageScipyInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // colour
        Text { text: "<b>colour</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageColourInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Decorator
        Text { text: "<b>decorator</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageDecoratorInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Pillow
        Text { text: "<b>Pillow</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packagePillowInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Fpdf
        Text { text: "<b>fpdf</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageFpdfInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // pygraphviz
        Text { text: "<b>pygraphviz</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packagePygraphvizInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // reportlab
        Text { text: "<b>reportlab</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageReportlabInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //pyparsing
        Text { text: "<b>pyparsing</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packagePyparsingInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // svgutils
        Text { text: "<b>svgutils</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageSvgutilsInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //svglib
        Text { text: "<b>svglib</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageSvglibInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //cython
        Text { text: "<b>Cython</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Text {
            property bool installed: dgsSettings.packageCythonInstalled
            text: installed ? "installed" : "not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        Item {Layout.fillHeight: true;}
        Item {Layout.fillHeight: true;}
        Item {Layout.fillHeight: true; Layout.fillWidth: true;}
        Item {Layout.fillHeight: true;}
        Item {Layout.fillHeight: true;}
    }
}
