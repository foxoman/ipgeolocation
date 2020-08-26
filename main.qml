import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Layouts 1.14

ApplicationWindow {
    visible: true
    title: qsTr("IP Geolocation")

    width: 600
    height: 720

    font.family: Qt.application.font.family

    font.pixelSize: Qt.application.font.pixelSize

    Material.accent: "#26c6da"
    Material.background: "#505659"
    Material.foreground: "#a3a4a6"
    Material.primary: "#484e50"

    property string url: "http://ip-api.com/json/" + ip.text.trim(
                             ) + "?fields=status,message,continent,continentCode,country,countryCode,region,regionName,city,zip,lat,lon,timezone,offset,currency,isp,org,as,query,asname,reverse,proxy"

    function getJSON() {

        statusLabel.text = qsTr("Updating ..")

        var xhr = new XMLHttpRequest
        xhr.open("GET", url)
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("xhr.status: " + xhr.status)
                var data = JSON.parse(xhr.responseText)
                ipdata.clear()

                console.log(JSON.stringify(data))

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
                                  "message": data.message
                              })
            }

            statusLabel.text = ""
        }
        xhr.send()
    }

    Dialog {
        id: aboutDlg
        modal: false
        standardButtons: Dialog.Ok
        title: qsTr("About!")
        anchors.centerIn: parent

        Pane {
            Material.elevation: 1
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
                    text: qsTr("1.0")
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
                    text: qsTr("Qt for WebAssembly 5.14!")
                }
            }
        }
    }

    header: ToolBar {
        Material.elevation: 1
        Material.foreground: "#a3a4a6"
        padding: 16

        RowLayout {
            anchors.fill: parent

            Label {
                text: "# IP Geolocation"
                textFormat: TextEdit.MarkdownText
                Layout.fillWidth: true
            }

            Label {
                id: statusLabel
            }

            ToolButton {
                text: "About"
                onClicked: aboutDlg.open()
            }
        }
    }

    Pane {
        anchors.fill: parent
        anchors.margins: 16
        Material.elevation: 2

        Material.background: Material.primaryColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16

            RowLayout {

                Layout.fillWidth: true
                Label {
                    text: "### Query:"
                    textFormat: TextEdit.MarkdownText
                }

                TextField {
                    id: ip
                    placeholderText: "0.0.0.0 / www"
                    Layout.minimumWidth: ip.contentWidth
                    text: "www.foxoman.net"
                    selectByMouse: true

                    onEditingFinished: {
                        getJSON()
                    }
                }

                Button {
                    text: "Search!"
                    flat: true
                    highlighted: true
                    onClicked: getJSON()
                }
            }
            Label {
                text: "**Query** can be a single ```IPv4/IPv6``` address or a ```domain``` name. If you don't supply a query the *current* IP address will be used."
                Layout.fillWidth: true
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: TextEdit.MarkdownText
                onLinkActivated: Qt.openUrlExternally(link)
                color: Material.color(Material.Orange)
                padding: 16
            }

            ListView {

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
                        text: "**IP:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: query
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Continent:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: continent + "_" + continentCode
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Country:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: country + "_" + countryCode
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Region:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: regionName + "_" + region
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**City:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: city
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Latitude:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: lat
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Longitudes:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: lon
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**TimeZone:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: timezone
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Offset:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: offset
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Currency:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: currency
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**ISP name:**"
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: isp
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Organization name:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: org
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**AS number and organization:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: as
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**AS name (RIR):**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: asname
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Reverse DNS of the IP:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: reverse
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Proxy, VPN or Tor exit address:**"
                        textFormat: TextEdit.MarkdownText
                    }
                    Label {
                        text: proxy
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: "**Status:**"
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        textFormat: TextEdit.MarkdownText
                    }

                    Label {
                        text: (status === "success" ? status : status + " " + message)
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        textFormat: TextEdit.MarkdownText
                        color: (status === "success" ? Material.color(
                                                           Material.Green) : Material.color(
                                                           Material.Red))
                    }
                }
            }
        }
    }
}
