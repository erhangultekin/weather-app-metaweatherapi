import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather/class/information_forecast.dart';

// ignore: camel_case_types
class cityInformation extends StatefulWidget {
  final String woeid;
  final String city;
  cityInformation({Key? key, required this.woeid, required this.city})
      : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<cityInformation> {
  Future<List<Weather>> _getData() async {
    var a = 0;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy/M/').format(now);
    String formattedDay = DateFormat('dd').format(now);
    List<Weather> weathers = [];
    for (var i = 1; i <= 7; i++) {
      a = int.parse(formattedDay) + i - 1;
      var data = await http.get(
          'https://www.metaweather.com/api/location/${widget.woeid}/$formattedDate${a.toString()}');
      var jsonData = json.decode(data.body);
      if (data.statusCode == 200) {
        Weather weather = Weather(
            jsonData[0]['id'].toString(),
            jsonData[0]['weather_state_name'].toString(),
            jsonData[0]['weather_state_abbr'].toString(),
            jsonData[0]['wind_direction_compass'].toString(),
            jsonData[0]['created'].toString(),
            jsonData[0]['applicable_date'].toString(),
            jsonData[0]['min_temp'].toString(),
            jsonData[0]['max_temp'].toString(),
            jsonData[0]['the_temp'].toString(),
            jsonData[0]['wind_speed'].toString(),
            jsonData[0]['wind_direction'].toString(),
            jsonData[0]['air_pressure'].toString(),
            jsonData[0]['humidity'].toString(),
            jsonData[0]['visibility'].toString(),
            jsonData[0]['predictability'].toString());
        weathers.add(weather);
        debugPrint(weathers.length.toString());
      } else {
        throw Exception();
      }
    }
    return weathers;
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
              "WEEKLY FORECAST",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
            future: _getData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Weather>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        trailing: Image.network(
                            'https://www.metaweather.com/static/img/weather/png/${snapshot.data![index].weatherStateAbbr}.png'),
                        title: Text(
                          (double.parse(
                                      snapshot.data![index].theTemp.toString()))
                                  .round()
                                  .toString() +
                              "°C",
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Icon(Icons.date_range, color: Colors.black87),
                            Text(
                              " " +
                                  snapshot.data![index].applicableDate
                                      .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.black87))),
                          child: Text(widget.city.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      );
                    });
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  'https://images.hdqwalls.com/download/clouds-summer-weather-5k-1b-480x854.jpg'))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Loading...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            margin: EdgeInsets.all(10),
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
