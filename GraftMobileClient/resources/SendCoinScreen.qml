import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "components"
import "wallet"

BaseScreen {
    id: sendOrScanScreen
    title: qsTr("Send")
    screenHeader.actionButtonState: true
    action: checkingData
    onErrorMessage: busyIndicator.running = false
    onNetworkReplyError: pushScreen.openPaymentScreen(false, true)

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            screenHeader.actionText = qsTr("Send")
        }
    }

    Connections {
        target: GraftClient

        onTransferFeeReceived: {
            busyIndicator.running = false
            enableScreen()
            if (result) {
                pushScreen.openSendConfirmationScreen(receiversAddress.text,
                                                      coinsAmountTextField.text, fee)
            }
        }
    }

    Connections {
        target: sendOrScanScreen
        onAttentionAccepted: qRScanningView.resetView()
    }

    StackLayout {
        id: stackLayout
        focus: true
        anchors.fill: parent
        onCurrentIndexChanged: {
            if (currentIndex === 1) {
                sendOrScanScreen.screenHeader.repeatFocus = true
                sendOrScanScreen.enabled = true
                sendOrScanScreen.screenHeader.actionButtonState = false
                sendOrScanScreen.specialBackMode = changeBehaviorButton
            } else {
                sendOrScanScreen.screenHeader.repeatFocus = false
                sendOrScanScreen.screenHeader.actionButtonState = true
                sendOrScanScreen.specialBackMode = null
            }
            // TODO: (Fixed in - 5.11.0 Alpha) QTBUG-51321. StackView should clear focus when a new item is pushed. For more details see:
            // https://bugreports.qt.io/browse/QTBUG-51321?jql=component%20%3D%20%22Quick%3A%20Controls%202%22%20AND%20text%20~%20%22Tab%22
            currentItem.nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
        }

        Item {
            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 15
                }
                spacing: 0

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    LinearEditItem {
                        id: receiversAddress
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        maximumLength: 106
                        wrapMode: TextField.WrapAnywhere
                        inputMethodHints: Qt.ImhNoPredictiveText
                        title: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                   qsTr("Receiver's address:") : qsTr("Receiver's address")
                        validator: RegExpValidator {
                            regExp: GraftClient.networkType() === GraftClientTools.Mainnet ?
                                        /(^G[0-9A-Za-z]{105}|^G[0-9A-Za-z]{94})/ :
                                        /(^F[0-9A-Za-z]{105}|^F[0-9A-Za-z]{94})/
                        }
                    }

                    LinearEditItem {
                        id: coinsAmountTextField
                        Layout.fillWidth: true
                        title: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                   qsTr("Amount:") : qsTr("Amount")
                        showLengthIndicator: false
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        validator: RegExpValidator {
                            regExp: priceRegExp()
                        }

                        Label {
                            anchors {
                                right: parent.right
                                bottom: parent.bottom
                                bottomMargin: 10
                            }
                            color: "#BBBBBB"
                            font {
                                pixelSize: 16
                                bold: true
                            }
                            text: qsTr("GRFT")
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                WideActionButton {
                    id: scanQRcodeButton
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    text: qsTr("Scan QR Code")
                    onClicked: {
                        sendOrScanScreen.enabled = false
                        stackLayout.currentIndex = 1
                    }
                }

                WideActionButton {
                    id: sendCoinsButton
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                    text: qsTr("Send")
                    KeyNavigation.tab: sendOrScanScreen.Navigation.implicitFirstComponent
                    onClicked: checkingData()
                }
            }
        }

        QRScanningView {
            id: qRScanningView
            KeyNavigation.tab: sendOrScanScreen.Navigation.implicitFirstComponent
            onQrCodeDetected: {
                if (GraftClient.isCorrectAddress(message)) {
                    receiversAddress.text = message
                    changeBehaviorButton()
                } else {
                    screenDialog.text = qsTr("QR Code data is wrong. \nPlease, scan correct QR Code.")
                    screenDialog.open()
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    function changeBehaviorButton() {
        stackLayout.currentIndex = 0
        qRScanningView.stopScanningView()
    }

    function checkingData() {
        if (receiversAddress.text.length === 0) {
            screenDialog.text = qsTr("Receiver's address is empty! Please input correct account " +
                                     "address.")
            screenDialog.open()
        } else if (receiversAddress.text.length !== 106 && receiversAddress.text.length !== 95) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("Receiver's address is invalid! Please input correct " +
                                     "account address.")
            screenDialog.open()
        } else if ((0.0001 > coinsAmountTextField.text) || (coinsAmountTextField.text > 100000.0)) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("The amount must be more than 0 and less than 100 000! " +
                                     "Please input correct value.")
            screenDialog.open()
        } else if (GraftClient.balance(GraftClientTools.UnlockedBalance) < coinsAmountTextField.text) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("The amount which you want to send is higher than you have " +
                                     "on your wallet. Please, enter a smaller amount.")
            screenDialog.open()
        } else {
            disableScreen()
            busyIndicator.running = true
            GraftClient.transferFee(receiversAddress.text, coinsAmountTextField.text)
        }
    }
}
