import QtQuick 2.9
import "../"
import "../components"

BaseScreen {
    id: root

    property real totalAmount: 0
    property var productModel

    title: qsTr("Pay")
    screenHeader {
        navigationButtonState: true
    }

    Connections {
        target: GraftClient

        onPayReceived: {
            if (result !== true) {
                pushScreen.openBalanceScreen()
            }
        }

        onPayStatusReceived: {
            if (result !== true) {
                pushScreen.openBalanceScreen()
            }
        }
    }

    function confirmPay() {
        GraftClient.pay()
        pushScreen.openPaymentScreen()
    }

    function cancelPay() {
        GraftClient.rejectPay()
        pushScreen.openBalanceScreen()
    }
}
