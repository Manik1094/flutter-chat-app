import 'dart:async';

import 'package:chat_app/chatscreen.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<DocumentSnapshot> _users;
  CollectionReference _collectionReference;
  StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionReference = Firestore.instance.collection('Users');
    _subscription = _collectionReference.snapshots().listen((dataSnapshot) {
      setState(() {
        _users = dataSnapshot.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.close, color: Colors.white,),
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context ,new MaterialPageRoute(builder: (context) => new HomePage()));


                })
          ],
          title: Text('All Users' ,style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.deepPurple,
        ),
        body: _users != null
            ? new ListView.builder(

                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    onTap: (){
                      Navigator.push(context ,new MaterialPageRoute(builder: (context) => new ChatScreen(_users[index].data)));


                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_users[index].data['profilePhoto']),
                    ),
                    title: new Text(_users[index].data['name']),
                    subtitle: Text(_users[index].data['status']),
                  );
                },

              )
            : new Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.pink,
                ),
              ));
  }
}
