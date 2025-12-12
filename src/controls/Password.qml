import QtQuick
import QtQml
import QtQml.Models
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui
import org.kde.novastore 1.0
import Qt5Compat.GraphicalEffects

Maui.Page {
    id: passwordPage

    headBar.visible: false
    Maui.Theme.colorSet: Maui.Theme.View

    Component.onCompleted: {

        image.opacity = 1.0
        image.scale = 1.0

        rectangle.opacity = 1.0
        rectangle.scale = 1.0

        input.opacity = 1.0
        input.scale = 1.0

    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Image {
            id: image

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            width: parent.width / 2 - 10 - anchors.leftMargin
            height: parent.height
            source: "qrc:/assets/password.png"

            scale: 1.0 + Math.random() * 0.4
            opacity: 0

            Behavior on scale {
                NumberAnimation {
                    duration: 1500
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 1500
                }
            }
        }
        Maui.ShadowedRectangle {
            id: rectangle

            anchors.right: parent.right
            anchors.top: parent.top
            width: parent.width / 2 - 10
            height: parent.height
            corners.topLeftRadius: 0
            corners.bottomLeftRadius: 0
            radius: 10
            color: "#00DF82"

            scale: 1.0 + Math.random() * 0.4
            opacity: 0

            Behavior on scale {
                NumberAnimation {
                    duration: 1500
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 1500
                }
            }
        }
    }

    Rectangle {
        id: input

        anchors.centerIn: parent
        width: 400
        height: 400
        radius: 10
        color: Maui.Theme.backgroundColor

        scale: 1.0 + Math.random() * 0.4
        opacity: 0

        Behavior on scale {
            NumberAnimation {
                duration: 1500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 1500
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            radius: 10
            color: "#00DF82"
            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20
                height: 180
                spacing: 20
                Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    font.pixelSize: 30
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Bold
                    text: "Verify your identity"
                }
                Maui.TextField {
                    onAccepted: {
                        password = text
                        _stackView.push("Management.qml")
                    }
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: 5
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    font.pixelSize: 20
                    placeholderText: "Enter password .."
                    leftPadding: 15
                    echoMode: TextInput.Password
                    background: Rectangle {
                        anchors.fill: parent
                        anchors.rightMargin: -5
                        color: "transparent"
                        border.color: Maui.Theme.textColor
                        border.width: 2
                        radius: 40
                        clip: true
                    }
                }
            }
        }
    }
}
