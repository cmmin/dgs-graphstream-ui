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
        Text { text: "DGS Graphstream Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtGraphstreamDirectory
            Layout.preferredWidth: 400
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

        // END DGS Program Directory


        // DGS Program Path
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

        // END DGS Program Path


        // Oslom2 Program Directory
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
        Text { text: "OSLOM2 Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtOslom2Dir
            Layout.preferredWidth: 400
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

        // END Oslom2

        // Oslom2 Program Path
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

        // END Oslom2 Program Path


        // Infomap Program Directory
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
        Text { text: "Infomap Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtInfomapDir
            Layout.preferredWidth: 400
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

        // END Infomap

        // Infomap Program Path
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

        // END Infomap Program Path


        // Gvmap Program Directory
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
        Text { text: "Gvmap Program Directory"; font.family: "Ubuntu"; font.pixelSize: 12; }
        BasicComponents.Textfield {
            id: txtGvmapDir
            Layout.preferredWidth: 400
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

        // END Gvmap

        // Gvmap Program Path
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

        // END Gvmap Program Path

        // Montage Program
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
        Text { text: "Montage Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }

        BasicComponents.Textfield {
            id: txtMontageProgramPath
            Layout.preferredWidth: 400

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

        // END Montage Program

        // Ffmpeg Program
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
        Text { text: "Ffmpeg Program Path"; font.family: "Ubuntu"; font.pixelSize: 12; }

        BasicComponents.Textfield {
            id: txtFfmpegProgramPath
            Layout.preferredWidth: 400

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
        // END Ffmpeg Program


        // python modules
        Text {
            property bool installed: dgsSettings.packageNetworkxInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>networkx</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // nxmetis
        Text {
            property bool installed: dgsSettings.packageNxmetisInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>nxmetis</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // configparser
        Text {
            property bool installed: dgsSettings.packageConfigparserInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>configparser</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // pydot
        Text {
            property bool installed: dgsSettings.packagePydotInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>pydot</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // scipy
        Text {
            property bool installed: dgsSettings.packageScipyInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>scipy</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // colour
        Text {
            property bool installed: dgsSettings.packageColourInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>colour</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Decorator
        Text {
            property bool installed: dgsSettings.packageDecoratorInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>decorator</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Pillow
        Text {
            property bool installed: dgsSettings.packagePillowInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>Pillow</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // Fpdf
        Text {
            property bool installed: dgsSettings.packageFpdfInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>fpdf</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // pygraphviz
        Text {
            property bool installed: dgsSettings.packagePygraphvizInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>pygraphviz</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // reportlab
        Text {
            property bool installed: dgsSettings.packageReportlabInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>reportlab</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //pyparsing
        Text {
            property bool installed: dgsSettings.packagePyparsingInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>pyparsing</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        // svgutils
        Text {
            property bool installed: dgsSettings.packageSvgutilsInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>svgutils</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //svglib
        Text {
            property bool installed: dgsSettings.packageSvglibInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>svglib</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
        Item {Layout.fillWidth: true;}
        Item {width:1}
        Item {width:1}

        //cython
        Text {
            property bool installed: dgsSettings.packageCythonInstalled
            text: installed ? "Installed" : "Not installed"
            color: installed ? "#009E6A" : "#E24670"
        }
        Text { text: "<b>Cython</b>"; font.family: "Ubuntu"; font.pixelSize: 12; }
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
