import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQml 2.2

ApplicationWindow {
    id: root
    title: "Hanzi SRS"
    visible: true
    width: 800
    height: 300

    menuBar: MenuBar {
        Menu {
            title: "File"
            Menu {
                title: "Import..."
                MenuItem { text: "From CSV" }
                MenuItem { text: "From TSV" }
                MenuItem { text: "From Excel" }
                MenuItem { text: "From Anki package (*.apkg)" }
            }
            Menu {
                title: "Export..."
                MenuItem { text: "To CSV" }
                MenuItem { text: "To TSV" }
                MenuItem { text: "To Excel" }
                MenuItem { text: "To AnkiConnect" }
            }
            MenuSeparator {}
            MenuItem { text: "Backup database" }
            MenuItem { text: "Load from backup" }
            MenuSeparator {}
            MenuItem { text: "Quit" }
        }

        Menu {
            title: "Explore"
            MenuItem {
                text: "Vocabulary dictionary"
                onTriggered: {
//                    openNewWindow("vocab_dict.qml")
                }
            }
            MenuItem {
                text: "Vocabulary by category"
                onTriggered: {
                    var component = Qt.createComponent("vocab_category.qml")
                    var win = component.createObject(root)
                    win.activated.connect(openNewVocabWindow)
                }
            }
            MenuSeparator {}
            MenuItem { text: "Random Hanzi" }
            MenuItem {
                text: "Read a sentence"
                onTriggered: {
                    openNewWindow('sentence_explorer.qml')
                }
            }
        }

        Menu {
            title: "Statistics"
            MenuItem { text: "Vocabularies" }
            MenuItem {
                text: "Hanzi"
                onTriggered: {
                    openNewWindow("hanzi_stat.qml")
                }
            }
            MenuItem { text: "Reading" }
            MenuSeparator {}
            MenuItem { text: "Summary" }
        }

        Menu {
            title: "Settings"
            MenuItem {
                text: "Preferences"
                onTriggered: {
                    openNewWindow('preferences.qml')
                }
            }
        }

        Menu {
            title: "About"
            MenuItem { text: "About Hanzi SRS" }
            MenuItem { text: "About Hanzi Level Project" }
            MenuSeparator {}
            MenuItem { text: "Contributing" }
            MenuItem { text: "Other projects" }
        }
    }

    ColumnLayout {
        id: main
        anchors.fill: parent
        anchors.margins: 10

        RowLayout {
            id: vocabRow
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                Label {
                    text: "Vocabulary level : "
                }
                Label {
                    id: vocabLevel
                }
            }

            RowLayout {
                anchors.right: parent.right

                Button {
                    id: vocabNewButton
                    text: "New"
                    onClicked: {
                        openNewVocabWindow([])
                    }
                }
                Button {
                    id: vocabLearningButton
                    text: "Learning"
                    enabled: false
                }
                Button {
                    id: vocabReviewButton
                    text: "Review"
                    enabled: false
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            ProgressBar {
                id: vocabProgressBar
                value: 0  // Between 0 and 1
                Layout.fillWidth: true
            }
            Label {
                id: vocabProgressPercentage
                text: "  0%"
            }
        }

        RowLayout {
            id: hanziRow
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                Label {
                    text: "Hanzi level : "
                }
                Label {
                    id: hanziLevel
                }
            }

            RowLayout {
                anchors.right: parent.right

                Button {
                    id: hanziNewButton
                    text: "New"
                    enabled: false
                    onClicked: {
                        openNewWindow('hanzi_new.qml')
                    }
                }
                Button {
                    id: hanziLearningButton
                    text: "Learning"
                    enabled: false
                }
                Button {
                    id: hanziReviewButton
                    text: "Review"
                    enabled: false
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            ProgressBar {
                id: hanziProgressBar
                value: 0  // Between 0 and 1
                Layout.fillWidth: true
            }
            Label {
                id: hanziProgressPercentage
                text: "  0%"
            }
        }

        RowLayout {
            id: readingRow
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                Label {
                    text: "Reading level : "
                }
                Label {
                    id: readingLevel
                }
            }

            RowLayout {
                anchors.right: parent.right

                Button {
                    id: readingNewButton
                    text: "New"
                    enabled: false
                }
                Button {
                    id: readingLearningButton
                    text: "Learning"
                    enabled: false
                }
                Button {
                    id: readingReviewButton
                    text: "Review"
                    enabled: false
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            ProgressBar {
                id: readingProgressBar
                value: 0  // Between 0 and 1
                Layout.fillWidth: true
            }
            Label {
                id: readingProgressPercentage
                text: "  0%"
            }
        }
    }

    function openNewWindow(qml) {
        var component = Qt.createComponent(qml)
        if( component.status != Component.Ready )
        {
            if( component.status == Component.Error )
                console.debug("Error:"+ component.errorString() );
            return; // or maybe throw
        }
        component.createObject(root)
    }

    function openNewVocabWindow(tags) {
        var component = Qt.createComponent("vocab_new.qml")
        var win = component.createObject(root, {'tags': tags})
//        win.tags = tags
    }

    Component.onCompleted: {
        var vocabDump = pyUserVocab.get_dump
        if(vocabDump.length > 0){
            hanziNewButton.enabled = true
            readingNewButton.enabled = true
        }
        for(var i=0; i<vocabDump.length; i++){
            if(vocabDump[i][-3] === '1') vocabLearningButton.enabled = true
            if(vocabDump[i][-3] === '2') vocabReviewButton.enabled = true
        }
    }
}