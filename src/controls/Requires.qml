import QtQuick
import QtQml
import QtQml.Models
import QtQml.XmlListModel
import QtQuick.Controls
import QtQuick.Layouts
import org.mauikit.controls as Maui
import org.kde.novastore 1.0
import Qt5Compat.GraphicalEffects
import Async 1.0

Maui.Page {
    id: requiresPage

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

    XmlListModel {
        id: requireList

        source: "file:///tmp/requires.xml"
        query: "/stream/search-result/solvable-list/solvable"

        XmlListModelRole { name: "name"; elementName: ""; attributeName: "name" }
        XmlListModelRole { name: "summary"; elementName: ""; attributeName: "summary" }
        XmlListModelRole { name: "kind"; elementName: ""; attributeName: "kind" }
        XmlListModelRole { name: "status"; elementName: ""; attributeName: "status" }
    }

    Async {
        id: task
    }

    Connections {
        target: task
        onTaskCompleted: {
            itemsInGroup.includeByDefault = true
            requireList.reload()
            gridView.opacity = 1.0
        }
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
                text: "Requires"

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
                placeholderText: "Find packages that require a specific package"
                leftPadding: 15

                onTextChanged: gridView.opacity = 0.7

                onAccepted: {
                    task.setOperation("get-requires")
                    task.setQuery(text)
                    task.start()
                }

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

                font.pixelSize: 20
                text: requireListFiltered.count + " results"

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

            GridView {
                id: gridView

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: -10
                cellWidth: 200
                cellHeight: 200
                clip: true
                model: requireListFiltered

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

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
        }

        DelegateModel {
            id: requireListFiltered

            groups: [
                DelegateModelGroup {
                    id: itemsInGroup
                    includeByDefault: false
                    name: "itemsInGroup"
                }
            ]

            filterOnGroup: "itemsInGroup"

            model: requireList

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
                            preferredwidth = 0
                            _stackView.push("Password.qml")
                        }
                    }
                }
            }
        }
    }
}
