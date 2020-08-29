import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Universal 2.15

ApplicationWindow {

    // Ap window Property
    visible: true
    title: qsTr("IP Geolocation")

    // Window Size
    width: 800
    height: 600
    minimumWidth: mainbar.implicitWidth

    // App Style
    //font.pixelSize: Qt.application.font.pixelSize
    font.family: virtue.name
    Universal.accent: Universal.Crimson

    // App Property
    property string url: "http://ip-api.com/json/" + ip.text.trim(
                             ) + "?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,zip,lat,lon,timezone,offset,currency,isp,org,as,query,asname,reverse,proxy"
    readonly property string hereApiKey: "4KfBfqjOP7HxE0Vf8abraL1M3Hhrjm6iXLvr48d2hfs"
    property string asSub: ""
    property string asLink: ""
    property string map: ""

    // Get JSON Function
    function getJSON() {

        alert.show(qsTr("Updating .."))

        var xhr = new XMLHttpRequest
        xhr.open("GET", url)
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var data = JSON.parse(xhr.responseText)
                ipdata.clear()

                if (data.status === "success") {
                    map = "https://maps.google.com/?q=" + data.lat + "," + data.lon
                    asSub = data.as.substr(0, data.as.indexOf(' '))
                    asLink = "[" + data.as + "]" + "(https://bgp.he.net/" + asSub + ")"

                    ipdata.append({
                                      "status": data.status,
                                      "query": data.query,
                                      "continent": data.continent,
                                      "continentCode": data.continentCode,
                                      "country": data.country,
                                      "countryCode": data.countryCode,
                                      "regionName": data.regionName,
                                      "region": data.region,
                                      "city": data.city,
                                      "lat": data.lat,
                                      "lon": data.lon,
                                      "timezone": data.timezone,
                                      "offset": data.offset,
                                      "currency": data.currency,
                                      "isp": data.isp,
                                      "org": data.org,
                                      "as": data.as,
                                      "asname": data.asname,
                                      "reverse": data.reverse,
                                      "proxy": data.proxy,
                                      "message": ""
                                  })
                }

                if (data.status === "fail") {
                    map = ""
                    asSub = ""
                    asLink = ""

                    ipdata.append({
                                      "status": data.status,
                                      "query": data.query,
                                      "continent": "",
                                      "continentCode": "",
                                      "country": "",
                                      "countryCode": "",
                                      "regionName": "",
                                      "region": "",
                                      "city": "",
                                      "lat": 0,
                                      "lon": 0,
                                      "timezone": "",
                                      "offset": 0,
                                      "currency": "",
                                      "isp": "",
                                      "org": "",
                                      "as": "",
                                      "asname": "",
                                      "reverse": "",
                                      "proxy": false,
                                      "message": data.message
                                  })
                }
            }

            alert.hide()
        }
        xhr.send()
    }

    // Load the App Font
    FontLoader {
        id: virtue
        source: "virtue.ttf"
    }

    // About dialog
    Dialog {
        id: aboutDlg
        modal: false
        standardButtons: Dialog.Ok
        title: qsTr("About!")
        anchors.centerIn: parent

        Pane {
            spacing: 16

            GridLayout {
                anchors.fill: parent
                columns: 2
                columnSpacing: 8

                Label {
                    text: qsTr("# IP Geolocation")
                    textFormat: TextEdit.MarkdownText
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                }

                Label {
                    text: qsTr("*Version:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("1.1")
                }

                Label {
                    text: qsTr("*Developer:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("Sultan Al Isaiee")
                }

                Label {
                    text: qsTr("*Blog:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("www.foxoman.net")
                }

                Label {
                    text: qsTr("*Email:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("sultan@foxoman.net")
                }

                Label {
                    text: qsTr("*Built With:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("Qt for WebAssembly 5.15!")
                }

                Label {
                    text: qsTr("*API:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("http://ip-api.com")
                }

                Label {
                    text: qsTr("*Map:*")
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("www.here.com")
                }
            }
        }
    }

    // App Toolbar
    header: ToolBar {
        id: mainbar
        padding: 16

        RowLayout {
            anchors.fill: parent

            // App title
            Label {
                text: qsTr("# IP Geolocation")
                textFormat: TextEdit.MarkdownText
                Layout.fillWidth: true
                Universal.foreground: Universal.Crimson
            }

            RowLayout {

                Layout.fillWidth: true
                Label {
                    text: qsTr("### Query:")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Olive
                }

                TextField {
                    id: ip
                    placeholderText: "0.0.0.0 / www"
                    Layout.minimumWidth: ip.contentWidth + 20
                    implicitWidth: 200
                    selectByMouse: true

                    onEditingFinished: {
                        getJSON()
                    }
                }

                Button {
                    icon.source: "/icons/magnifier.svg"
                    onClicked: getJSON()
                }
            }

            ToolButton {
                icon.source: "/icons/information-button.svg"
                onClicked: aboutDlg.open()
            }
        }
    }

    ToolTip {
        id: alert
        anchors.centerIn: parent
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 32

        Label {
            text: qsTr("**Query** can be a single ```IPv4/IPv6``` address or a ```domain``` name. If you don't supply a query the *current* IP address will be used.")
            Layout.fillWidth: true
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: TextEdit.MarkdownText
            onLinkActivated: Qt.openUrlExternally(link)
            color: Universal.color(Universal.Orange)
            padding: 8
        }

        ListView {

            ScrollBar.vertical: ScrollBar {
                hoverEnabled: true
                active: hovered || pressed
            }
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: ListModel {
                id: ipdata
            }
            clip: true
            delegate: GridLayout {
                columns: 2
                columnSpacing: 12

                Label {
                    text: qsTr("**Status:**")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }

                Label {
                    text: (status === "success" ? status : status + " " + message)
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    textFormat: TextEdit.MarkdownText
                    color: (status === "success" ? Universal.color(
                                                       Universal.Green) : Universal.color(
                                                       Universal.Red))
                }

                Label {
                    text: qsTr("**IP:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: query
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Continent:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: continent + "_" + continentCode
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Country:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: country + "_" + countryCode
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Region:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: regionName + "_" + region
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**City:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: city
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Latitude / Longitudes:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: lat + " / " + lon
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Location Map:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }

                Image {
                    id: ig
                    source: Qt.resolvedUrl(
                                "https://image.maps.ls.hereapi.com/mia/1.6/mapview?apiKey="
                                + hereApiKey + "&c=" + lat + "," + lon)
                    width: 240
                    height: 320

                    property string toolTipText: qsTr("Click to Open Location in Google Map!")
                    ToolTip.text: toolTipText
                    ToolTip.visible: toolTipText ? ma.containsMouse : false

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(map)
                        hoverEnabled: true
                    }

                    BusyIndicator {
                        running: ig.status == Image.Loading
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Label {
                    text: qsTr("**TimeZone:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: timezone
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Offset:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: offset
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Currency:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: currency
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**ISP name:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }

                Label {
                    text: isp
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Organization name:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: org
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**AS number and organization:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: asLink
                    textFormat: TextEdit.MarkdownText
                    onLinkActivated: Qt.openUrlExternally(link)
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }

                Label {
                    text: qsTr("**AS name (RIR):**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: asname
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Reverse DNS of the IP:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: reverse
                    textFormat: TextEdit.MarkdownText
                }

                Label {
                    text: qsTr("**Proxy, VPN or Tor exit address:**")
                    textFormat: TextEdit.MarkdownText
                    Universal.foreground: Universal.Cobalt
                }
                Label {
                    text: proxy
                    textFormat: TextEdit.MarkdownText
                }
            }
        }
    }
}
