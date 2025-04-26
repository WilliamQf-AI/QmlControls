import QtQuick 2.15
import QtQuick.Controls 2.15
import DelegateUI 1.0

DelWindow {
    id: root

    width: 900
    height: 600
    title: qsTr("代码运行器")
    captionBar.closeCallback:
        () => {
            root.destroy();
        }
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    Component.onCompleted: {
        setSpecialEffect(DelWindow.DwmBlur);
        DelApi.setWindowStaysOnTopHint(root, true);
    }

    property var created: undefined

    function createQmlObject(code) {
        codeEdit.text = code;
        updateCode();
    }

    function updateCode() {
        try {
            errorEdit.clear();
            if (created)
                created.destroy();
            created = Qt.createQmlObject(codeEdit.text, runnerBlock);
        } catch (error) {
            errorEdit.text = error.message;
        }
    }

    DelDivider {
        id: divider
        width: parent.width
        height: 1
        anchors.top: captionBar.bottom
    }

    Item {
        id: content
        width: parent.width
        anchors.top: divider.bottom
        anchors.bottom: parent.bottom

        Item {
            id: codeBlock
            width: parent.width * 0.4
            height: parent.height

            Flickable {
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: divider1.top
                contentWidth: codeEdit.width
                contentHeight: codeEdit.height
                ScrollBar.vertical: DelScrollBar { }
                ScrollBar.horizontal: DelScrollBar { }
                clip: true

                TextArea {
                    id: codeEdit
                    color: DelTheme.DelCopyableText.colorText
                    selectByMouse: true
                    selectByKeyboard: true
                    selectedTextColor: DelTheme.DelCopyableText.colorSelectedText
                    selectionColor: DelTheme.DelCopyableText.colorSelection
                    font {
                        family: DelTheme.DelCopyableText.fontFamily
                        pixelSize: DelTheme.DelCopyableText.fontSize
                    }
                }
            }

            DelDivider {
                id: divider1
                width: parent.width
                height: 10
                anchors.bottom: errorView.top
                title: qsTr("错误")
            }

            ScrollView {
                id: errorView
                width: parent.width
                height: 100
                anchors.bottom: parent.bottom

                TextArea {
                    id: errorEdit
                    readOnly: true
                    selectByKeyboard: true
                    selectByMouse: true
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorError
                    wrapMode: Text.WordWrap
                }
            }
        }

        DelDivider {
            id: divider2
            width: 10
            height: parent.height
            anchors.left: codeBlock.right
            orientation: Qt.Vertical
            titleAlign: DelDivider.Align_Center
            titleDelegate: DelIconButton {
                padding: 5
                iconSize: DelTheme.Primary.fontPrimarySizeHeading4
                iconSource: DelIcon.PlayCircleOutlined
                onClicked: {
                    root.updateCode();
                }
                DelToolTip {
                    visible: parent.hovered
                    text: qsTr("运行")
                }
            }
        }

        Item {
            id: runnerBlock
            anchors.left: divider2.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
        }
    }
}
