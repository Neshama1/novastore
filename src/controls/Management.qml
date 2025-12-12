import QtCore
import QtQuick
import QtQml
import QtQml.XmlListModel
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import org.mauikit.controls as Maui
import org.kde.novastore 1.0
import Qt5Compat.GraphicalEffects
import Async 1.0

Maui.Page {
    id: managementPage

    headBar.visible: false
    Maui.Theme.colorSet: Maui.Theme.View

    Async {
        id: task
    }

    Component.onCompleted: {

        // ANIMATIONS

        scale = 1.0
        opacity = 1.0

        // PACKAGE

        task.setPackage(currentpackage)
        task.setPassword(password)
        task.setOperation(operation)
        task.start()
    }

    Connections {
        target: task
        function onTaskCompleted(error) {
            back.visible = true
            detail.text = error === 0 ? "Finished" : "Error"
            error === 0 ? refresh() : undefined
        }
    }

    scale: 1.1 + Math.random() * 0.3
    opacity: 0

    Behavior on scale {
        NumberAnimation {
            duration: 1000 + Math.random() * 1000
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 400 + Math.random() * 200
        }
    }

    Button {
        id: back
        anchors.right: info.left
        anchors.verticalCenter: info.verticalCenter
        anchors.rightMargin: 100
        icon.width: 48
        icon.height: 48
        icon.name: "arrow-left"
        visible: false
        flat: true
        onClicked: {
            preferredwidth = 250
            _stackView.pop()
            _stackView.pop()
        }
    }

    Rectangle {
        id: info

        anchors.centerIn: parent
        width: 200
        height: 200
        radius: width
        color: "#00DF82"
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width
            height: 100
            spacing: 10
            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                font.pixelSize: 40
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                font.weight: Font.Bold
                text: operation == "get" ? "+" : "-"
            }
            Label {
                id: detail
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
                font.pixelSize: 20
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: operation == "get" ? "Installing .." : "Removing .."
            }
        }
    }
}
