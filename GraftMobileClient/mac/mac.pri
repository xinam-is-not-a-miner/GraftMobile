LIBS += -framework Foundation \
        -framework Carbon \
        -framework IOKit

contains(DEFINES, POS_BUILD) {
BUILD_DIR = $$PWD/pos

DISTFILES += \
    $$BUILD_DIR/Info.plist \
    $$BUILD_DIR/icon.icns
}
contains(DEFINES, WALLET_BUILD) {
BUILD_DIR = $$PWD/wallet

DISTFILES += \
    $$BUILD_DIR/Info.plist \
    $$BUILD_DIR/icon.icns
}

QMAKE_INFO_PLIST = $${BUILD_DIR}/Info.plist
ICON = $${BUILD_DIR}/icon.icns

CONFIG(release, debug|release) {

ESCAPE_COMMAND = $$escape_expand(\\n\\t)

QT_DEPLOY = $$QMAKE_QMAKE
QT_DEPLOY ~= s,qmake,macdeployqt,g

QML_DIR = $$QMAKE_QMAKE
QML_DIR ~= s,bin/qmake,qml,g

APP_FILE = $${OUT_PWD}/$${DESTDIR}/$${TARGET}.app

DEVID_CER = \"Developer ID Application: GRAFT Payments, LLC (5E52LHPZLS)\"
CODESIGN = codesign --force --verify --deep --sign $$DEVID_CER
BACKGROUND = $${BUILD_DIR}/graft_background.tiff

!contains(DEFINES, DISABLE_SPARKLE_UPDATER) {
DSA_PUB_PEM = $$BUILD_DIR/dsa_pub.pem

exists($${DSA_PUB_PEM}) {
    DISTFILES += DSA_PUB_PEM

    DSA_KEY.files = $${DSA_PUB_PEM}
    DSA_KEY.path = Contents/Resources
    QMAKE_BUNDLE_DATA += DSA_KEY
}
}

CREATE_DMG_SH += $$PWD/create_dmg.sh
exists($${CREATE_DMG_SH}) {
QMAKE_POST_LINK += $${QT_DEPLOY} $$APP_FILE -qmldir=$${QML_DIR} $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${CODESIGN} $$APP_FILE $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${CREATE_DMG_SH} -s $$APP_FILE -o $${OUT_PWD} -b $${BACKGROUND} $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${CREATE_DMG_SH} -s $$APP_FILE -o $${OUT_PWD} -b $${BACKGROUND} $${ESCAPE_COMMAND}
}
}
