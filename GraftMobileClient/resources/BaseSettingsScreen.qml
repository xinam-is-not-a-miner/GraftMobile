import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Settings")
    action: saveChanges

    property alias companyTitle: companyNameTextField.title
    property alias ipTitle: ipTextField.title
    property alias portTitle: portTextField.title
    property alias saveButtonText: saveButton.text
    property alias displayCompanyName: companyNameTextField.visible

    function saveChanges() {
        if (companyNameTextField.visible) {
            GraftClient.setSettings("companyName", companyNameTextField.text)
        }
        GraftClient.setSettings("useOwnServiceAddress", serviceAddr.checked)
        GraftClient.resetUrl(ipTextField.text, portTextField.text)
        GraftClient.saveSettings()
        pushScreen.openMainScreen()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        LinearEditItem {
            id: companyNameTextField
            maximumLength: 50
            Layout.topMargin: 10
            Layout.alignment: Qt.AlignTop
            text: GraftClient.settings("companyName") ? GraftClient.settings("companyName") : ""
        }

        ColumnLayout {
            Layout.topMargin: 10
            Layout.fillWidth: true
            spacing: 2

            Label {
                text: qsTr("Service")
                font.pointSize: Qt.platform.os === "ios" ? 14 : switchLabel.font.pointSize
                color: "#BBBBBB"
            }

            RowLayout {
                spacing: 0

                Label {
                    id: switchLabel
                    Layout.fillWidth: true
                    Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                    text: qsTr("Use own service address")
                }

                Switch {
                    id: serviceAddr
                    Material.accent: ColorFactory.color(DesignFactory.Foreground)
                    checked: GraftClient.useOwnServiceAddress("useOwnServiceAddress")
                }
            }

            RowLayout {
                id: serviceAddrLayout
                enabled: serviceAddr.checked
                spacing: 20

                LinearEditItem {
                    id: ipTextField
                    inputMask: "999.999.999.999; "
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: RegExpValidator {
                        regExp: /\d/
                    }
                    showLengthIndicator: false
                    text: GraftClient.useOwnServiceAddress("useOwnServiceAddress") ? GraftClient.settings("ip") : ""
                }

                LinearEditItem {
                    id: portTextField
                    Layout.preferredWidth: root.width / 4
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    text: GraftClient.useOwnServiceAddress("useOwnServiceAddress") ? GraftClient.settings("port") : ""
                    validator: RegExpValidator {
                        regExp: /\d{5}/
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: saveButton
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            onClicked: saveChanges()
        }
    }
}
