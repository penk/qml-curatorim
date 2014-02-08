#include <QtQuick/QQuickView>
#include <QtGui/QGuiApplication>
#if QT_VERSION > QT_VERSION_CHECK(5, 1, 0)
#include <QQmlApplicationEngine>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    view.setSource(QUrl("./main.qml"));
    view.show();

    return app.exec();
}
