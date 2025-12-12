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
import QtQuick.Effects

Maui.Page
{
    id: homePage

    headBar.visible: false

    property var tags: ["player", "youtube", "messaging", "radio", "music", "news", "rss", "draw", "paint", "image editor", "bible", "scan", "ocr", "viewer", "browser", "mail", "chat", "net", "ftp", "smb", "converter"]

    Component.onCompleted: {

        banner.scale = 1.0
        banner.opacity = 1.0

        applications.scale = 1.0
        applications.opacity = 1.0

        packages.scale = 1.0
        packages.opacity = 1.0

        requires.scale = 1.0
        requires.opacity = 1.0

        provides.scale = 1.0
        provides.opacity = 1.0

        tagblock.scale = 1.0
        tagblock.opacity = 1.0

        storeasset.scale = 1.0
        storeasset.opacity = height < 800 ? 0.1 : 1.0

        wallpaper.source = SystemInfo.getWallpaper()

        console.info("Wallpaper", SystemInfo.getWallpaper())
    }

    Maui.ImageColors {
        id: wallpaper
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 40

        Rectangle {
            id: banner
            Layout.fillWidth: true
            Layout.topMargin: Screen.height < 800 ? 40 : 50
            height: Screen.height < 800 ? 150 : 200

            radius: 10
            color: "transparent"

            scale: 1.0 + Math.random() * 0.1
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

            Maui.IconItem {
                anchors.fill: parent
                imageSource: "qrc:/assets/banner-up.png"
                fillMode: Image.PreserveAspectCrop
                maskRadius: 10
            }

            Maui.IconItem {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                imageSizeHint: parent.height * 1.4
                //imageSizeHint: Screen.height < 800 ? parent.height * 1.2 : parent.height * 1.4
                imageSource: "qrc:/assets/about-store.png"
                fillMode: Image.PreserveAspectCrop
                visible: Screen.height < 800 ? false : true
            }
        }

        ColumnLayout {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 120
            spacing: 10

            Label {
                font.pixelSize: 20
                text: "Search the repository"
            }

            RowLayout {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 80
                //Layout.preferredHeight: Screen.height < 800 ? 65 : 80
                spacing: 20

                Rectangle {
                    id: applications

                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: wallpaper.highlight
                    //color: "chartreuse"
                    radius: 10

                    scale: 1.2 + Math.random() * 0.2
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

                    Maui.FlexSectionItem {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        width: parent.width

                        label1.font.weight: Font.Bold
                        label1.text: "Applications"

                        label2.elide: Text.ElideRight
                        label2.maximumLineCount: 1
                        label2.text: "Search for applications"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _stackView.push("Applications.qml")
                    }

                    MultiEffect {
                        anchors.fill: parent
                        source: applications
                        saturation: 0.6
                    }
                }

                Rectangle {
                    id: packages

                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: wallpaper.average
                    //color: "dimgrey"
                    radius: 10

                    scale: 1.1 + Math.random() * 0.4
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

                    Maui.FlexSectionItem {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        width: parent.width

                        label1.font.weight: Font.Bold
                        label1.text: "Packages"

                        label2.elide: Text.ElideRight
                        label2.maximumLineCount: 1
                        label2.text: "Search for all packages"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _stackView.push("Packages.qml")
                    }

                    MultiEffect {
                        anchors.fill: parent
                        source: packages
                        saturation: 0.5
                    }
                }

                Rectangle {
                    id: requires

                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: wallpaper.dominant
                    //color: "#03624C"
                    radius: 10

                    scale: 1.1 + Math.random() * 0.1
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

                    Maui.FlexSectionItem {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        width: parent.width

                        label1.font.weight: Font.Bold
                        label1.text: "Requires"

                        label2.elide: Text.ElideRight
                        label2.maximumLineCount: 1
                        label2.text: "Query a required package"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _stackView.push("Requires.qml")
                    }

                    MultiEffect {
                        anchors.fill: parent
                        source: requires
                        saturation: 0.8
                    }
                }

                Rectangle {
                    id: provides

                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: Qt.lighter(wallpaper.dominant, 1.4)
                    //color: "#00DF82"
                    radius: 10

                    scale: 1.1 + Math.random() * 0.5
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

                    Maui.FlexSectionItem {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        width: parent.width

                        label1.font.weight: Font.Bold
                        label1.text: "Provides"

                        label2.elide: Text.ElideRight
                        label2.maximumLineCount: 1
                        label2.text: "Query the package for an alias"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: _stackView.push("Provides.qml")
                    }

                    MultiEffect {
                        anchors.fill: parent
                        source: provides
                        saturation: 0.2
                    }
                }
            }
        }

        ColumnLayout {
            Layout.preferredWidth: parent.width / 1.5
            Layout.preferredHeight: 80
            spacing: 10

            Label {
                font.pixelSize: 20
                text: "Search for apps by suggested terms"
            }

            Flow {
                id: tagblock

                Layout.preferredWidth: parent.width
                spacing: 10

                scale: 1.1 + Math.random() * 0.2
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

                Repeater {
                    model: tags
                    delegate: Maui.Chip {
                        id: chip

                        height: 40
                        color: "#906E6D6C"
                        text: tags[index]

                        onClicked: {
                            tag = text
                            opentag = true
                            _stackView.push("Applications.qml")
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            color: "lightgrey"
        }
    }

    Maui.IconItem {
        id: storeasset

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: -300
        imageSizeHint: 800
        imageSource: "qrc:/assets/novastore.png"
        fillMode: Image.PreserveAspectCrop
        z: -1
        visible: Screen.height < 800 ? false : true

        Connections {
            target: root
            onHeightChanged: storeasset.opacity = height < 800 ? 0.1 : 1
        }

        scale: 1.1 + Math.random() * 0.2

        Behavior on scale {
            NumberAnimation {
                duration: 1500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
    }
}
