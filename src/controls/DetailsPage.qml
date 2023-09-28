import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB
import org.kde.novastore 1.0
import QtGraphicalEffects 1.15
import Async 1.0
import org.kde.kirigami 2.12 as Kirigami

Maui.Page
{
    id: detailsPage

    headBar.visible: false

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
        getDetail()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: detailsPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 250
    }

    PropertyAnimation {
        id: xAnimation
        target: detailsPage
        properties: "x"
        from: -20
        to: 0
        duration: 500
    }

    Async {
        id: threadAsync
    }

    property string detailname
    property string detailversion
    property string detailsummary
    property string detaildescription
    property string detailinstalled

    function getDetail() {
            detailname = AppBackend.package[0].name
            detailversion = AppBackend.package[0].version
            detailsummary = AppBackend.package[0].summary
            detaildescription = AppBackend.package[0].description
            detailinstalled = AppBackend.package[0].installed
    }

    // MAIN INFO

    Rectangle {
        id: mainInfo

        Maui.Theme.colorSet: Maui.Theme.Window
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        height: 150
        radius: 5
        color: Maui.Theme.backgroundColor
        Maui.Theme.inherit: false
        Label {
            id: packageLabel
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            text: detailname
            font.pixelSize: 30
            elide: Qt.ElideRight
        }
        Label {
            id: packageSummary
            anchors.top: packageLabel.bottom
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 5
            text: detailsummary
            font.pixelSize: 15
        }
        Maui.Chip
        {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 10
            color: "pink"
            text: detailversion
        }
        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: 100
            height: 40
            text: detailinstalled == "No" ? "Get" : "Remove"
            background: Rectangle {
                anchors.fill: parent
                radius: 4
                color: detailinstalled == "No" ? (buttonMouse.hovered ? Qt.lighter('mediumspringgreen',1.3) : 'mediumspringgreen') : (buttonMouse.hovered ? Qt.lighter('deeppink',1.3) : 'deeppink')
            }
            onClicked: {
                detailinstalled == "No" ? threadAsync.setOperation("get") : threadAsync.setOperation("remove")
                installedDialog.visible = false
                passwordDialog.visible = true
            }
            HoverHandler {
                id: buttonMouse
            }
        }
    }

    // DESCRIPTION

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainInfo.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 20
        //height: 150
        radius: 5
        color: Qt.lighter(Maui.Theme.backgroundColor,1.03)
        Maui.Theme.colorSet: Maui.Theme.Window
        Maui.Theme.inherit: false
        Label {
            anchors.fill: parent
            anchors.margins: 10
            wrapMode: Text.WordWrap
            font.pixelSize: 15
            opacity: 0.60
            text: detaildescription
        }
    }

    // PASSWORD
    Kirigami.ShadowedRectangle {
        id: passwordDialog

        Kirigami.Theme.colorSet: Kirigami.Theme.View
        anchors.centerIn: parent
        visible: false
        opacity: 1
        width: parent.width - 100
        height: parent.height - 100
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.backgroundColor
        border.width: 2
        shadow.size: 20
        shadow.color: "#5c5c5c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 6
        z: 1

        Label {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            text: "Password"
            font.pointSize: 20
        }

        TextField {
            anchors.centerIn: parent
            width: 200
            placeholderText: i18n("Enter your password")
            echoMode: TextInput.Password
            onAccepted: {
                passwordDialog.visible = false
                installingDialog.visible = true
                threadAsync.setPackage(detailname)
                threadAsync.setPassword(text)
                threadAsync.start()
            }
        }
    }

    // INSTALLATION

    Kirigami.ShadowedRectangle {
        id: installingDialog

        Kirigami.Theme.colorSet: Kirigami.Theme.View
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
        visible: false
        opacity: 1
        width: parent.width - 200
        height: 70
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.backgroundColor
        border.width: 2
        shadow.size: 20
        shadow.color: "#5c5c5c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 6
        z: 1

        Label {
            anchors.centerIn: parent
            text: detailinstalled == "No" ? "Installing" : "Uninstalling"
        }
    }

    Kirigami.ShadowedRectangle {
        id: installedDialog

        Kirigami.Theme.colorSet: Kirigami.Theme.View
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
        visible: false
        opacity: 1
        width: parent.width - 200
        height: 70
        color: Kirigami.Theme.backgroundColor
        border.color: Kirigami.Theme.backgroundColor
        border.width: 2
        shadow.size: 20
        shadow.color: "#5c5c5c"
        shadow.xOffset: 0
        shadow.yOffset: 0
        radius: 6
        z: 1

        Label {
            anchors.centerIn: parent
            text: detailinstalled == "No" ? "Uninstallation completed" : "Installation completed"
        }

        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            width: 90
            height: 30
            text: "Ok"
            onClicked: {
                installedDialog.visible = false
            }
        }
    }

    Connections {
        target: threadAsync
        onInstallationCompleted: {
            installingDialog.visible = false
            if (error == 0)
            {
                installedDialog.visible = true

                //Update DetailsPage
                AppBackend.detail(AppBackend.package[0].name)
                getDetail()

                // Update SearchPage
                appModel.clear()
                AppBackend.updateState()
                root.readAppModel()
            }
        }
    }
}
