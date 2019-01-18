import 'package:chat_app/homepage.dart';
import 'package:chat_app/userslist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String phoneNo;
  String smsCode;
  String verificationId;
  bool isLoggedIn;
  DocumentReference _documentReference;


  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      print('Inside autoRetrieve');
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((user) {
        print('Signed in');
      });
    };

    final PhoneVerificationCompleted verificationSuccess = (FirebaseUser user) {
      print('Verified');
    };

    final PhoneVerificationFailed verificationFail = (Exception e) {
      print('Inside Verification fail');
      print(e);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFail);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Enter sms code'),
            content: new TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      print('User iddd : ${user.uid}');

                      _documentReference = Firestore.instance.collection('Users').document(user.uid);

                      _documentReference.get().then((snapShot){
                        if(snapShot.exists){

                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => UsersList()));

                        }else{

                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => DashboardPage()));

                        }
                      });




                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() {
    FirebaseAuth.instance
        .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
        .then((user) {
          print('User iddd : ${user.uid}');
      _documentReference = Firestore.instance.collection('Users').document(user.uid);

      _documentReference.get().then((snapShot){
        if(snapShot.exists){

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => UsersList()));

        }else{

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => DashboardPage()));

        }
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Manik"),
      ),
      body: new Center(
          child: new Container(
        padding: EdgeInsets.all(25.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Enter phone Number'),
              onChanged: (value) {
                this.phoneNo = value;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Verify'),
              textColor: Colors.white,
              elevation: 7.0,
              color: Colors.red,
              onPressed: verifyPhone,
            )
          ],
        ),
      )),
    );
  }
}
