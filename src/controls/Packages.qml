import QtQuick
import QtQml
import QtQml.Models
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui
import org.kde.novastore 1.0
import Qt5Compat.GraphicalEffects

Maui.Page {
    id: packagesPage

    property bool loading: false

    headBar.visible: false
    Maui.Theme.colorSet: Maui.Theme.View

    Component.onCompleted: {

        pagename.scale = 1.0
        pagename.opacity = 1.0

        textfield.scale = 1.0
        textfield.opacity = 1.0

        results.scale = 1.0
        results.opacity = 1.0

        gridView.scale = 1.0
        gridView.opacity = 1.0

    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        ColumnLayout {

            Layout.fillWidth: true
            Layout.topMargin: 40
            spacing: 15

            Label {
                id: pagename

                width: parent.width
                font.pixelSize: 30
                font.weight: Font.Bold
                text: "Packages"

                scale: 1.0 + Math.random() * 0.2
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

            Maui.TextField {
                id: textfield

                Layout.preferredWidth: 400
                Layout.preferredHeight: 50
                font.pixelSize: 20
                placeholderText: "Search for packages .."
                leftPadding: 15

                onTextChanged: gridView.opacity = 0.7
                onAccepted: search(text)

                scale: 1.0 + Math.random() * 0.2
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

                background: Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: -5
                    color: "transparent"
                    border.color: Maui.Theme.textColor
                    border.width: 2
                    radius: 40
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 10
            Label {
                id: results

                width: parent.width
                font.pixelSize: 20
                text: packageListFiltered.count + " results"

                scale: 1.0 + Math.random() * 0.2
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

                Maui.ProgressIndicator {
                    id: indicator
                    anchors.top: parent.bottom
                    width: parent.width
                    height: 2
                    visible: false
                }
            }

            GridView {
                id: gridView

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: -10
                cellWidth: 200
                cellHeight: 200
                clip: true

                model: packageListFiltered

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

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
            }
        }

        Rectangle {
            Layout.fillHeight: true
            color: "transparent"
        }

        DelegateModel {
            id: packageListFiltered

            groups: [
                DelegateModelGroup {
                    id: itemsInGroup
                    includeByDefault: true
                    name: "itemsInGroup"
                }
            ]

            filterOnGroup: "itemsInGroup"

            model: packageList

            delegate: Rectangle {

                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 10

                    color: status == "installed" ? "#FF1498" : "#00DF82"

                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        Label {
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.preferredWidth: parent.width
                            text: name
                            font.weight: Font.Bold
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }
                        Label {
                            Layout.preferredWidth: parent.width
                            text: summary
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                        }
                        Rectangle {
                            Layout.fillHeight: true
                            color: "transparent"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            currentpackage = name
                            operation = status == "installed" ? "remove" : "get"
                            packagekind = "package"
                            preferredwidth = 0
                            _stackView.push("Password.qml")
                        }
                    }
                }
            }
        }
    }

    function search(query)
    {
        // FILTER MODEL

        query = query.toLowerCase()

        // Reset

        var count = itemsInGroup.count
        itemsInGroup.remove(0, count)

        // Filter

        console.info("query", query)

        for (var i = 0; i < packageList.count; i++) {
            var name = packageListFiltered.items.get(i).model.name
            var summary = packageListFiltered.items.get(i).model.summary

            name = name.toLowerCase()
            summary = summary.toLowerCase()
            name.includes(query) || summary.includes(query) ? packageListFiltered.items.addGroups(i, 1, "itemsInGroup") : undefined
        }

        // SET READY

        gridView.opacity = 1.0
    }
}
