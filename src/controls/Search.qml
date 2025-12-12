import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui
import org.kde.novastore 1.0

Maui.Page
{
    id: searchPage

    headBar.visible: false

    Component.onCompleted: {
        opacityAnimation.start()
        xAnimation.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: searchPage
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 400
    }

    PropertyAnimation {
        id: xAnimation
        target: searchPage
        properties: "x"
        from: 20
        to: 0
        duration: 400
    }

    Maui.ListBrowser {
        id: appView
        anchors.fill: parent
        anchors.margins: 20

        horizontalScrollBarPolicy: ScrollBar.AsNeeded
        verticalScrollBarPolicy: ScrollBar.AsNeeded

        spacing: 5

        model: xml

        //model: appModel

        delegate: Maui.ListBrowserDelegate {
            implicitWidth: parent.width	// anchura de un elemento de la lista
            implicitHeight: 55		// altura de un elemento de la lista

            iconSource: status == "not-installed" ? "noninstalled" : "installed"
            label1.text: name
            label2.text: summary

            onClicked: {
                appView.currentIndex = index
                AppBackend.detail(name)
                _stackView.push("Details.qml")
                console.info("pulsado")
            }
        }
    }
}
