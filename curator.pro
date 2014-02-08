TEMPLATE = app
TARGET = curatorim

QT += qml quick 
SOURCES += main.cpp
RESOURCES += resources.qrc

mac: {
    #CONFIG -= app_bundle
}
