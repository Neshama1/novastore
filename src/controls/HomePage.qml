import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB
import org.kde.novastore 1.0
import QtGraphicalEffects 1.15

Maui.Page
{
    id: homePage

    headBar.visible: false

    RowLayout {
        y: - 50
        id: layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        height: 300
        spacing: 6
        Rectangle {
            color: merkuroMouse.hovered ? Qt.lighter('teal',1.1) : 'teal'
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: 150
            Layout.maximumWidth: 300
            Layout.minimumHeight: 150
            radius: 4
            clip: true
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "Merkuro"
                font.pixelSize: 24
            }
            Image {
                x: 100
                y: -800
                scale: 0.13
                opacity: 0.70
                source: "https://cdn.kde.org/screenshots/merkuro/contact.png"
                transform: Rotation { origin.x: 0; origin.y: 0; angle: 45}
                z: 1
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("merkuro")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: merkuroMouse
            }
        }
        Rectangle {
            color: kastsMouse.hovered ? Qt.lighter('plum',1.1) : 'plum'
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 150
            Layout.preferredHeight: 150
            radius: 4
            clip: true
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                text: "Kasts"
                font.pixelSize: 24
            }
            Image {
                x: parent.width - 600
                y: 70
                scale: 0.20
                opacity: 0.85
                source: "https://cdn.kde.org/screenshots/kasts/kasts-desktop.png"
                transform: Rotation { origin.x: 0; origin.y: 0; angle: -45}
                z: 1
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("kasts")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: kastsMouse
            }
        }
    }

    RowLayout {
        y: 190
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 6
        Rectangle {
            color: elisaMouse.hovered ? Qt.lighter('pink',1.1) : 'pink'
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 200
            Layout.preferredHeight: 70
            radius: 4
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Elisa"
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Music player"
                opacity: 0.60
                font.pixelSize: 11
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("elisa")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: elisaMouse
            }
        }
        Rectangle {
            color: alligatorMouse.hovered ? Qt.lighter('plum',1.1) : 'plum'
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 200
            Layout.preferredHeight: 70
            radius: 4
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Alligator"
                opacity: 0.70
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Feed reader"
                opacity: 0.60
                font.pixelSize: 11
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("alligator")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: alligatorMouse
            }
        }
        Rectangle {
            color: angelfishMouse.hovered ? Qt.lighter('plum',1.1) : 'plum'
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 200
            Layout.preferredHeight: 70
            radius: 4
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Angelfish"
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Web browser"
                opacity: 0.60
                font.pixelSize: 11
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("angelfish")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: angelfishMouse
            }
        }
    }

    Label {
        x: 20
        y: 270
        text: "More"
        font.pixelSize: 30
    }

    ColumnLayout{
        y: 320
        spacing: 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20

        Rectangle {
            color: indexMouse.hovered ? Qt.lighter('plum',1.1) : 'plum'
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 70
            radius: 4
            clip: true
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Index"
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Multi-platform file manager based in MauiKit"
                opacity: 0.60
                font.pixelSize: 11
            }
            Image {
                x: parent.width - 650
                y: -400
                scale: 0.25
                opacity: 0.70
                source: "qrc:../assets/index.png"
                transform: Rotation { origin.x: 0; origin.y: 0; angle: 0}
                z: 1
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("maui-index")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: indexMouse
            }
        }

        Rectangle {
            color: vvaveMouse.hovered ? Qt.lighter('lightgreen',1.1) : 'lightgreen'
            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 70
            radius: 4
            clip: true
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Vvave"
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Music player to manage your music collection and stream it from the cloud"
                opacity: 0.60
                font.pixelSize: 11
            }
            Image {
                x: parent.width - 50
                y: -450
                scale: 0.25
                opacity: 0.40
                source: "qrc:../assets/vvave.png"
                transform: Rotation { origin.x: 0; origin.y: 0; angle: 45}
                z: 1
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("maui-vvave")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: vvaveMouse
            }
        }

        Rectangle {
            color: pixMouse.hovered ? Qt.lighter('lightpink',1.1) : 'lightpink'
            Layout.alignment: Qt.AlignBottom
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 70
            radius: 4
            Text {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 15
                text: "Pix"
                font.pixelSize: 16
            }
            Text {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.margins: 15
                text: "Image gallery and viewer with basic editing features"
                opacity: 0.60
                font.pixelSize: 11
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    AppBackend.detail("maui-pix")
                    _stackView.push("qrc:/DetailsPage.qml")
                    menuView.currentIndex = -1;
                }
            }
            HoverHandler {
                id: pixMouse
            }
        }
    }
}
