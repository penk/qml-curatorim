import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0

Window {
    id: root
    title: "小海嚴選" 
    width: 960
    height: 600
    Component {
        id: delegate
        Column { 
            Image {
                width: 300
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: 'http://'+ description.match(new RegExp('media.curator.im(.*)jpg'))[0];
            }
            Text { text: title; anchors.horizontalCenter: parent.horizontalCenter }
        }
    }
    XmlListModel {
        id: model
        source: "http://feeds.feedburner.com/curator-stream"
        query: "/rss/channel/item"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
    }
    GridView {
        id: view
        anchors { fill: parent; leftMargin: 10 }
        cellWidth: width/3; cellHeight: 450;
        model: model 
        delegate: delegate
    }
}
