import QtQuick 2.0
import org.graft 1.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: balanceScreen

    BalanceScreen {
        id: balanceScreen
        amountUnlockGraft: GraftClient.balance(GraftClientTools.UnlockedBalance)
        amountLockGraft: GraftClient.balance(GraftClientTools.LockedBalance)
        pushScreen: walletsTransitions()
    }

    function walletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openQRCodeScanner"] = openQRScanningScreen
        transitionsMap["addCardScreen"] = openAddCardScreen
        transitionsMap["openPaymentConfirmationScreen"] = openPaymentConfirmationScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["openAddAccountScreen"] = openAddAccountScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openQRScanningScreen() {
        stack.push("qrc:/wallet/QRScanningScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openAddCardScreen() {
        stack.push("qrc:/wallet/AddCardScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openPaymentConfirmationScreen() {
        stack.push("qrc:/wallet/PaymentConfirmationScreen.qml", {
                       "pushScreen": walletsTransitions(),
                       "productModel": PaymentProductModel})
    }

    function openMainScreen() {
        stack.pop(balanceScreen)
    }

    function openPaymentScreen(state) {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": openMainScreen,
                       "title": qsTr("Pay"), "isSpacing": true, "completeText": qsTr("Paid complete!"),
                       "screenState": state})
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletsTransitions(),
                       "coinModel": CoinModel})
    }
}