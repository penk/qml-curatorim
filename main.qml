import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0

Window {
    width: 960
    height: 600
    title: "正妹流 | 小海嚴選"
    id: root
    visible: true
    property variant page: 1
    property variant token: "Put your token here.."

    Component.onCompleted: {
        fetchStream(page);
    }
    function fetchStream(page) {
        var xhr = new XMLHttpRequest();
        console.log('fetchStream: ', page);
        xhr.open("GET", "http://curator.im/api/stream/?token="+token+"&page="+page, true); 
        xhr.onreadystatechange = function() {
            if (xhr.readyState == xhr.DONE) {
                var response;
                try { response = JSON.parse(xhr.responseText); } catch (e) { console.error(e) }
                if (typeof response !== 'object') { console.log('Failed to load json: Malformed JSON'); }
                for (var i=0; i<response['results'].length; i++) {
                    switch(i%3) {
                        case 0:
                        leftModel.append({'title': response['results'][i].name,
                        'itemurl': response['results'][i].url,
                        'description': response['results'][i].image});
                        break;
                        case 1:
                        middleModel.append({'title': response['results'][i].name,
                        'itemurl': response['results'][i].url, 
                        'description': response['results'][i].image});
                        break;
                        case 2:
                        rightModel.append({'title': response['results'][i].name,
                        'itemurl': response['results'][i].url,
                        'description': response['results'][i].image});
                        break;
                    }
                }
            }
        }
        xhr.send();
    }
    Component {
        id: delegate
        Column { 
            Image {
                width: 300
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
                source: description 
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        (highlight.state == 'closed') ? highlight.state = 'opened' : highlight.state = 'closed';
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
    Flickable { 
        id: view
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: 400 * leftModel.count
        onAtYEndChanged: {
            console.log('onAtYEndChanged', view.atYEnd)
            if (view.atYEnd && !view.atYBeginning) {
                page++; 
                fetchStream(page);
            }
        }
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
            onClicked: { stage.visible = false; highlight.state = 'closed' }
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
                parent.state = 'closed'
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
}
