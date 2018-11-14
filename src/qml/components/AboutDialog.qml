import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0


Window {
    id: root
    title: qsTr("About Emergency Shelter Reunification Visualizer")


    width: 650
    height: 400

    minimumWidth: 600
    minimumHeight: 400

    modality: Qt.ApplicationModal

    Rectangle {
        id: content

        anchors.fill: parent

        //color: readaloStyle.aboutDialogBackground

        RowLayout {

            anchors.fill: parent

            Item {Layout.fillWidth: true }//width: 80 }

            ColumnLayout {

                Item {
                    height: 30
                }

                Text {
                    text: qsTr("Emergency Shelter Reunification Visualizer")
                    font.family: "Ubuntu"
                    font.pixelSize: 30
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    //color: readaloStyle.baseDarkFontColor
                }

                Text {
                    text: qsTr("A tool to generate visualizations for emergency shelter partitioning.");
                    font.family: "Open Sans"
                    font.pixelSize: 16
                    //color: readaloStyle.baseDarkFontColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    height: 40
                }

                Text {
                    text: qsTr("Version") + " - 1.0";
                    font.family: "Open Sans"
                    font.pixelSize: 14
                    font.bold: true
                    //color: readaloStyle.baseDarkFontColor
                    Layout.alignment: Qt.AlignHCenter
                }


                Text {
                    text: qsTr("Engineered by Nathaniel Douglass. User interface implemented by Carlo Minciacchi; dgs-graphstream implemented by Sami Barakat and Paul-Antoine Bittner.");
                    font.family: "Open Sans"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: root.width * 0.57
                    horizontalAlignment: Text.AlignHCenter
                    //color: readaloStyle.baseDarkFontColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    height: 30
                }
            }

            Item {Layout.fillWidth: true }
        }
    }
}
