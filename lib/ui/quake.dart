import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Quake extends StatelessWidget {
  Future<List> getAPIData() async {
    String apiURL =
        "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    http.Response response = await http.get(apiURL);
    var entireData = json.decode(response.body);
    return entireData["features"];
  }

  void _showOnTapMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('App'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text("OK"))
      ],
    );

    showDialog(context: context, child: alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quake Info'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: getAPIData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List _data = snapshot.data;
              return ListView.builder(
                  padding: EdgeInsets.all(2.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var timestamp = _data[index]["properties"]["time"];
                    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                    var formattedDate =
                        DateFormat.yMMMd().add_jm().format(date);

                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: new Text(
                                    "${_data[index]["properties"]["mag"].toString().toUpperCase()}",
                                    style: new TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white)),
                                radius: 30,
                                // backgroundImage: NetworkImage(_data[index]["properties"]['picture']['large'])
                              ),
                              title: Text(
                                "$formattedDate",
                                style: new TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "${_data[index]["properties"]["place"]}"),
                              onTap: () {
                                _showOnTapMessage(context,
                                    "${_data[index]["properties"]["title"]}");
                              })
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
