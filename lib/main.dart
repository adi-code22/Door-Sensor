// import 'dart:ffi';
import 'dart:ui';
// import 'dart:wasm';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final fbd = FirebaseDatabase.instance.reference();
  int nump = 56;
  bool value = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    writeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: value ? Colors.green[100] : Colors.red[100],
          body: StreamBuilder(
              stream: fbd.child("MainSwitch").onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data.snapshot.value != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              "Number of People in the Room",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            Text(
                              snapshot.data.snapshot.value["count"].toString(),
                              style: TextStyle(
                                  fontSize: 70,
                                  color: value
                                      ? Colors.green[900]
                                      : Colors.red[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: FlatButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                                splashColor: Colors.green,
                                onPressed: () {
                                  setState(() {
                                    value =
                                        snapshot.data.snapshot.value["count"] ??
                                            true;
                                  });
                                  fbd.child("MainSwitch").set({
                                    "switch":
                                        snapshot.data.snapshot.value["count"],
                                    "count":
                                        snapshot.data.snapshot.value["count"]
                                  });
                                },
                                child: Text(
                                  'ON',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Center(
                            child: FlatButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                                splashColor: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    value =
                                        snapshot.data.snapshot.value["count"] ??
                                            true;
                                  });
                                  fbd.child("MainSwitch").set({
                                    "switch": value,
                                    "count":
                                        snapshot.data.snapshot.value["count"]
                                  });
                                },
                                child: Text(
                                  'OFF',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Container(height: 20);
                }
              }),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              'Door Sensor',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }

  Future<void> writeData() {
    fbd.child("MainSwitch").set({"switch": value, "count": nump});
  }
}
