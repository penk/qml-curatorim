import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0

Item {
    id: root
    //title: "小海嚴選" 
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
    ListModel { id: leftModel }
    ListModel { id: middleModel }
    ListModel { id: rightModel }
    XmlListModel {
        id: model
        source: "http://feeds.feedburner.com/curator-stream"
        query: "/rss/channel/item"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        onStatusChanged: { 
            for (var i=0; i<model.count; i++) {
                switch(i%3) { 
                    case 0: 
                    leftModel.append({'title': model.get(i).title,
                    'description': model.get(i).description});
                    break;
                    case 1: 
                    middleModel.append({'title': model.get(i).title,
                    'description': model.get(i).description});
                    break;
                    case 2:
                    rightModel.append({'title': model.get(i).title,
                    'description': model.get(i).description});
                    break;
                }
            }
        }
    }
    Flickable { 
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: 450*model.count
        ListView {
            id: leftView
            interactive: false
            anchors { top: parent.top; left: parent.left; bottom: parent.bottom; leftMargin: 10 }
            width: 310
            model: leftModel 
            delegate: delegate
        }
        ListView {
            id: middleView
            interactive: false
            anchors { top: parent.top; left: leftView.right; bottom: parent.bottom; leftMargin: 10 }
            width: 310
            model: middleModel 
            delegate: delegate
        }
        ListView {
            id: rightView
            interactive: false
            anchors { top: parent.top; left: middleView.right; bottom: parent.bottom; leftMargin: 10 }
            width: 310
            model: rightModel 
            delegate: delegate
        }
    }
}
