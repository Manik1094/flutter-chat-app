import 'package:chat_app/models/User.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  Map<String,dynamic> user;
  ChatScreen(this.user);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.user['name'],style: TextStyle(color: Colors.white),),

      ),
      body: new Column(
        children: <Widget>[

          buildChatMessageLayout(),
        ],
      ),
    );
  }

  Widget buildChatMessageLayout(){

  }

}
