import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Window 2.2
import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FB
import org.kde.novastore 1.0
import org.kde.kirigami 2.12 as Kirigami

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Nova Store")

    property bool addRemovePackage: false

    width: Screen.height < 800 ? Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 40 / 100 : Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 45 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 20 / 100
    minimumHeight: 700

    Component.onCompleted: {
        _stackView.push("qrc:/HomePage.qml")
        animationTimer.start()
    }

    PropertyAnimation {
        id: opacityAnimation
        target: passwordDialog
        properties: "opacity"
        from: 0
        to: 1.0
        duration: 1000
    }

    PropertyAnimation {
        id: scaleAnimation
        target: passwordDialog
        properties: "scale"
        from: 0.9
        to: 1
        duration: 1000
    }

    Timer {
        id: animationTimer
        interval: 1500; running: true; repeat: false
        onTriggered: {
            opacityAnimation.start()
            scaleAnimation.start()
        }
    }

    ListModel {
    id: startMenuModel
        ListElement { name: "Home" ; description: "Home page" ; icon: "love" }
        ListElement { name: "Modern apps" ; description: "Modern apps" ; icon: "edit_animation" }
    }

    function readAppModel() {
        var fcount = AppBackend.count
        if (fcount > 500) {
            fcount = 500
        }
        for (var i = 0 ; i < fcount ; i++) {
            appModel.append({"status": AppBackend.packages[i].status,"name": AppBackend.packages[i].name,"summary": AppBackend.packages[i].summary,"kind": AppBackend.packages[i].kind})
        }
    }

    ListModel {
        id: appModel
    }

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent

        sideBarContent:  Maui.Page
        {
            anchors.fill: parent
            Maui.Theme.colorSet: Maui.Theme.Window

            headBar.leftContent: [
                Maui.ToolButtonMenu
                {
                    icon.name: "application-menu"

                    //MenuItem
                    //{
                    //    text: i18n("Settings")
                    //    icon.name: "settings-configure"
                    //}

                    MenuItem
                    {
                        text: i18n("About")
                        icon.name: "documentinfo"
                        onTriggered: root.about()
                    }
                }
            ]
            ListView {
                id: menuView
                anchors.fill: parent
                anchors.margins: 10

                spacing: 5

                model: startMenuModel
                delegate: Maui.ListBrowserDelegate
                {
                    id: list1
                    implicitWidth: parent.width
                    implicitHeight: 35
                    iconSource: icon
                    label1.text: name

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            switch (index) {
                                case 0: {
                                    if (addRemovePackage == false)
                                    {
                                        menuView.currentIndex = index
                                        _stackView.push("qrc:/HomePage.qml")
                                    }
                                    return
                                }
                                case 1: {
                                    if (addRemovePackage == false)
                                    {
                                        menuView.currentIndex = index
                                        AppBackend.listModernApps()
                                        appModel.clear()
                                        readAppModel()
                                        _stackView.clear()
                                        _stackView.push("qrc:/ModernAppsPage.qml")
                                    }
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }

        Maui.Page
        {
            anchors.fill: parent
            showCSDControls: true

            headBar.background: null
            headBar.leftContent: [
                ToolButton
                {
                    icon.name: "arrow-left"
                    onClicked: {
                        if (addRemovePackage == false)
                        {
                            _stackView.pop()
                        }
                    }
                }
            ]
            headBar.middleContent: [
                Maui.SearchField
                {
                    id: searchField
                    Layout.alignment: Qt.AlignHCenter
                    //placeholderText: i18n("Search...")
                    onAccepted: {
                        if (addRemovePackage == false)
                        {
                            appModel.clear()
                            AppBackend.search(text)
                            readAppModel()
                            _stackView.push("qrc:/SearchPage.qml")
                            menuView.currentIndex = -1;
                        }
                    }
                    //onCleared:
                }
            ]

            Kirigami.ShadowedRectangle {
                id: passwordDialog

                Kirigami.Theme.colorSet: Kirigami.Theme.View
                anchors.centerIn: parent
                opacity: 0
                width: 300
                height: 100
                color: Kirigami.Theme.backgroundColor
                border.color: Kirigami.Theme.backgroundColor
                border.width: 2
                shadow.size: 20
                shadow.color: "#5c5c5c"
                shadow.xOffset: 0
                shadow.yOffset: 0
                radius: 6
                z: 1

                TextField {
                    anchors.centerIn: parent
                    width: 250
                    placeholderText: i18n("Enter your password")
                    echoMode: TextInput.Password
                    onAccepted: {
                        passwordDialog.visible = false
                        AppBackend.refresh(text)
                    }
                }
            }

            StackView {
                id:_stackView
                anchors.fill: parent
                clip: true
            }
        }
    }
}
