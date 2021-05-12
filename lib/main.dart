import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/pages/location_page.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription? sub;
  bool isConnected = false;
  @override
  void initState() {
    //internet connection permission
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  String latlong = "";

  Future<String> _getCurrent() async {
    //position permission
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latlong = "${position.latitude},${position.longitude}";

    return latlong;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.hasData && snapshot.data != ConnectivityResult.none) {
              return Scaffold(
                body: FutureBuilder(
                    future: _getCurrent(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return MyHomePageBody(latlong: snapshot.data.toString());
                    }),
              );
            } else {
              return Scaffold(
                body: Container(
                  child: Center(
                      child: Icon(
                    Icons.wifi_off,
                    size: 65,
                  )),
                ),
              );
            }
          }),
    );
  }
}
