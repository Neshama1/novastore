import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.kde.novastore 1.0

Maui.Page {

    id: modernAppsPage

    headBar.visible: false

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: modernAppsPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 400
    }

    PropertyAnimation {
        id: xAnimation
        target: modernAppsPage
        properties: "x"
        from: 20
        to: 0
        duration: 400
    }

    ListView {
        id: appListView

        anchors.fill: parent
        anchors.margins: 20

        spacing: 5

        model: appModel
        delegate: Maui.ListBrowserDelegate
        {
            implicitWidth: parent.width
            implicitHeight: 55

            iconSource: status == "installed" ? "installed" : "noninstalled"
            label1.text: name
            label2.text: summary

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                onClicked: {
                    appListView.currentIndex = index
                    AppBackend.detail(AppBackend.packages[index].name)
                    _stackView.push("qrc:/DetailsPage.qml")
                }
            }
        }
    }
}
