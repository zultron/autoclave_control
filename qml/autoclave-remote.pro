TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creators code model
QML_IMPORT_PATH += $$PWD/autoclave-remote
QML_IMPORT_PATH += $$PWD/autoclave-remote/Autoclave

