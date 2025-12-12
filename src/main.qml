import QtCore
import QtQuick
import QtQml
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import org.mauikit.controls as Maui
import org.kde.novastore 1.0
import Qt5Compat.GraphicalEffects
import QtQml.XmlListModel
import Async 1.0
import org.kde.config as KC
import "controls"

Maui.ApplicationWindow
{
    id: root
    title: qsTr("")

    // THEME

    Maui.Style.styleType: themeManager.styleType
    Maui.Style.accentColor: themeManager.accentColor
    Maui.Style.defaultSpacing: themeManager.spacingSize
    Maui.Style.defaultPadding: themeManager.paddingSize
    Maui.Style.contentMargins: themeManager.marginSize
    Maui.Style.radiusV: themeManager.borderRadius

    ThemeManager {
        id: themeManager
    }

    // PROPERTIES

    property string tag
    property string currentpackage
    property string operation
    property string password
    property string packagekind
    property int packageindex
    property int preferredwidth: 250
    property bool opentag: false

    // WIDTH AND HEIGHT

    width: Screen.height < 800 ? Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 40 / 100 : Screen.desktopAvailableWidth - Screen.desktopAvailableWidth * 45 / 100
    height: Screen.desktopAvailableHeight - Screen.desktopAvailableHeight * 20 / 100
    minimumHeight: Screen.height < 800 ? 650 : 700

    // REPO TASKS

    // refresh task

    signal refresh()

    Async {
        id: refreshTask
    }

    Connections {
        target: root
        function onRefresh() {
            console.info("refrescar repositorio")
            refreshTask.setOperation("refresh")
            refreshTask.start()
        }
    }

    Connections {
        target: refreshTask
        function onTaskCompleted(error) {

            console.info("repositorio actualizado")
            console.info("actualizar lista de aplicaciones y paquetes")

            // GET APPS AND PACKAGES

            getAppsTask.setOperation("get-apps")
            getAppsTask.start()

            getPackagesTask.setOperation("get-packages")
            getPackagesTask.start()
        }
    }

    // get apps task

    Async {
        id: getAppsTask
    }

    Connections {
        target: getAppsTask
        function onTaskCompleted(error) {
            console.info("lista de aplicaciones actualizada")
            console.info("recargar modelo")
            appList.reload()
        }
    }

    // get packages task

    Async {
        id: getPackagesTask
    }

    Connections {
        target: getPackagesTask
        function onTaskCompleted(error) {
            console.info("lista de paquetes actualizada")
            console.info("recargar modelo")
            packageList.reload()
        }
    }

    // ON STARTING APP

    Component.onCompleted: {

        // GET APPS AND PACKAGES

        getAppsTask.setOperation("get-apps")
        getAppsTask.start()

        getPackagesTask.setOperation("get-packages")
        getPackagesTask.start()

        // HOME PAGE

        _stackView.push("controls/Home.qml")
    }

    // MODELS

    ListModel {
        id: startMenuModel
        ListElement { name: "Home" ; description: "Home page" ; icon: "bookmarks" }
        //ListElement { name: "Modern apps" ; description: "Modern apps" ; icon: "edit_animation" }
    }

    XmlListModel {
        id: appList

        source: "file:///tmp/apps.xml"
        query: "/stream/search-result/solvable-list/solvable"

        XmlListModelRole { name: "name"; elementName: ""; attributeName: "name" }
        XmlListModelRole { name: "summary"; elementName: ""; attributeName: "summary" }
        XmlListModelRole { name: "kind"; elementName: ""; attributeName: "kind" }
        XmlListModelRole { name: "status"; elementName: ""; attributeName: "status" }
    }

    XmlListModel {
        id: packageList

        source: "file:///tmp/packages.xml"
        query: "/stream/search-result/solvable-list/solvable"

        XmlListModelRole { name: "name"; elementName: ""; attributeName: "name" }
        XmlListModelRole { name: "summary"; elementName: ""; attributeName: "summary" }
        XmlListModelRole { name: "kind"; elementName: ""; attributeName: "kind" }
        XmlListModelRole { name: "status"; elementName: ""; attributeName: "status" }

        onStatusChanged: {
            status === XmlListModel.Ready ? console.info("modelo de paquetes listo") : undefined
        }
    }

    // HOME PAGE

    Maui.SideBarView
    {
        id: _sideBarView
        anchors.fill: parent

        sideBar.width: preferredwidth
        sideBar.preferredWidth: preferredwidth

        Behavior on sideBar.width {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutExpo
            }
        }

        sideBarContent:  Maui.Page
        {
            anchors.fill: parent

            Maui.Theme.colorSet: Maui.Theme.View

            headBar.background: null

            headBar.leftContent: [
                Maui.ToolButtonMenu
                {
                    icon.name: "application-menu"

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
                anchors.margins: 20

                spacing: 5

                model: startMenuModel
                delegate: Maui.ListBrowserDelegate
                {
                    id: list1
                    width: ListView.view.width
                    height: 60
                    //implicitWidth: parent.width
                    iconSizeHint: 32
                    iconSource: icon
                    //height: 60
                    label1.text: name
                    label1.font.pixelSize: 16
                    label1.font.weight: Font.Light

                    onClicked: {
                        switch (index) {
                            case 0: {
                                menuView.currentIndex = index
                                _stackView.push("controls/Home.qml")
                                return
                            }
                            case 1: {
                                menuView.currentIndex = index
                            }
                        }
                    }
                }
            }
        }

        Maui.Page
        {
            anchors.fill: parent

            Maui.Controls.showCSD: true

            floatingHeader: true

            headBar.background: null

            StackView {
                id:_stackView
                anchors.fill: parent
                clip: true
            }
        }
    }
}
