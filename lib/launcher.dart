import 'package:chat_app/homepage.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(new LauncherPage());
}

class LauncherPage extends StatefulWidget {
  @override
  LauncherPageState createState() {
    return new LauncherPageState();
  }
}

class LauncherPageState extends State<LauncherPage> {
  String uId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        uId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manik_updated',
      theme: ThemeData(primarySwatch: Colors.lime),
      home: checkStatus(),
    );
  }

  Widget checkStatus() {
    if (uId == null) {
      print("UID IS : ${this.uId}");

      return HomePage();
    } else {
      print("UID IS : ${this.uId}");
      return DashboardPage();
    }
  }
}


