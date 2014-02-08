import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0

Item {
    width: 960
    height: 600
    id: root
    Component {
        id: delegate
        Column { 
            Image {
                width: 300
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: 'http://'+ description.match(new RegExp('media.curator.im(.*)jpg'))[0];
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        (root.state == 'closed') ? root.state = 'opened' : root.state = 'closed';
                        stage.visible = true
                        highlight.source = parent.source
                        highlight.visible = true
                    }
                }
            }
            Text { 
                text: title; anchors.horizontalCenter: parent.horizontalCenter 
                lineHeight: 2 
            }
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
        XmlRole { name: "itemurl"; query: "guid/string()" }
        onStatusChanged: { 
            for (var i=0; i<model.count; i++) {
                switch(i%3) { 
                    case 0: 
                    leftModel.append({'title': model.get(i).title,
                    'itemurl': model.get(i).itemurl,
                    'description': model.get(i).description});
                    break;
                    case 1: 
                    middleModel.append({'title': model.get(i).title,
                    'itemurl': model.get(i).itemurl,
                    'description': model.get(i).description});
                    break;
                    case 2:
                    rightModel.append({'title': model.get(i).title,
                    'itemurl': model.get(i).itemurl,
                    'description': model.get(i).description});
                    break;
                }
            }
        }
    }
    Flickable { 
        id: view
        anchors.fill: root
        contentWidth: parent.width
        contentHeight: 450 * leftModel.count
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
    Rectangle { 
        id: stage
        visible: false
        anchors.fill: parent
        color: "black"
        opacity: 0.7
        MouseArea { 
            anchors.fill: parent;
            onClicked: { stage.visible = false; root.state = 'closed' }
        }
    }
    Image {
        id: highlight
        visible: false
        anchors.centerIn: parent
        height: parent.height
        fillMode: Image.PreserveAspectFit
        MouseArea { 
            anchors.fill: parent
            onClicked: { 
                //Qt.openUrlExternally()
                stage.visible = false; 
                root.state = 'closed'
            } 
        }
    }
    state: 'closed'
    states: [
        State{
            name: "opened"
            PropertyChanges { target: highlight; height: parent.height }
        },
        State {
            name: "closed"
            PropertyChanges { target: highlight; height: 0 }
        }
    ]
    transitions: [
        Transition {
            to: "*"
            NumberAnimation { target: highlight; properties: "height"; duration: 300; easing.type: Easing.InOutQuad; }
        }
    ]
}
