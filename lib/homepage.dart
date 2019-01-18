import 'dart:io';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/User.dart';
import 'package:chat_app/userslist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String uId;

  DocumentReference mUsersReference;

  File file;
  TextEditingController _nameController;
  TextEditingController _statusController;
  String imagPath;

  void getUid() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        this.uId = user.uid;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _statusController = new TextEditingController();
    getUid();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
  }

  Future getImage() async {
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (temp == null) {
      } else {
        file = temp;
      }
    });
    return file;
  }

  Future<String> uploadImageToStorage() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("profilePhoto").child(uId);

    StorageUploadTask task = await storageReference.putFile(file);


      var temp = await (await task.onComplete).ref.getDownloadURL();
      return temp;

  }

  void createAccount() {
    mUsersReference = Firestore.instance.collection('Users').document(uId);
    var user = User(
        name: this._nameController.text,
        status: this._statusController.text,
        uid: uId,
        profilePhoto: this.imagPath);
    var mMap = user.toMap();
    mUsersReference.setData(mMap).whenComplete(() {

      Navigator.pushReplacement(context ,new MaterialPageRoute(builder: (context) => new UsersList()));

      print('Account added successfully');
    }).catchError((e) => print(e));
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          // getImage();
          getImage();
        },
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: new ListView(
          children: <Widget>[
            file == null
                ? Text('Null')
                : Image.file(file, width: 300.0, height: 300.0),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'eg-Manik',
                  labelText: 'Your name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              controller: _nameController,
              onSubmitted: (value) {
                _nameController.text = value;
                print('Text : ${_nameController.text}');
              },
              onChanged: (value) {
                _nameController.text = value;
                print('Text : ${_nameController.text}');
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'ex - Hey there',
                  labelText: 'Your status',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)))),
              controller: _statusController,
              onSubmitted: (value) {
                _statusController.text = value;
                print('Text : ${_statusController.text}');
              },
              onChanged: (value) {
                _statusController.text = value;
                print('Text : ${_statusController.text}');
              },
            ),
            SizedBox(
              width: 60.0,
            ),
            RaisedButton(
              child: new Text(
                'Create Account',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              elevation: 10.0,
              onPressed: () {
                uploadImageToStorage().then((imagePath) {
                  this.imagPath = imagePath;
                  createAccount();
                }).catchError((e) => print(e));
                //createAccount();
              },
            )
          ],
        ),
      ),
    );
  }
}
