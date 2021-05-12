import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/class/information_city.dart';

import 'forecast_page.dart';

// ignore: must_be_immutable
class MyHomePageBody extends StatefulWidget {
  final String latlong;
  MyHomePageBody({Key? key, required this.latlong}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<MyHomePageBody> {
  Future<List<locations>> _getData() async {
    var response = await http.get(Uri.parse(
        'https://www.metaweather.com/api/location/search/?lattlong=${widget.latlong}'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((gelen) => locations.fromJsonMap(gelen))
          .toList();
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              "LOCATIONS",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: _getData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<locations>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        highlightColor: Colors.indigoAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => cityInformation(
                                woeid: snapshot.data![index].woeid.toString(),
                                city: snapshot.data![index].title.toString(),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: Text(
                            snapshot.data![index].title.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Icon(Icons.directions_car, color: Colors.black87),
                              Text("Distance :" +
                                  ((int.parse(snapshot.data![index].distance
                                              .toString()) *
                                          1 /
                                          1000))
                                      .round()
                                      .toString() +
                                  "km"),
                            ],
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black87,
                            size: 30,
                          ),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black87))),
                            child: Icon(Icons.location_pin, color: Colors.blue),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
