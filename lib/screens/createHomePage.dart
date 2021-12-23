// ignore_for_file: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_harcama_app/model/HomeModel.dart';
import 'package:hexcolor/hexcolor.dart';

import 'home.dart';

class CreateHomePage extends StatefulWidget {
  String email;
  String uid;
  CreateHomePage({Key? key, required this.email, required this.uid}) : super(key: key);

  @override
  _CreateHomePageState createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<CreateHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('#00BFB2'),
        title: Text(
          'Create New Home',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      body: Body(uid: widget.uid, email: widget.email),
    );
  }
}

class Body extends StatefulWidget {
  String? uid;
  String? email;
  Body({this.uid, this.email});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
   FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
   TextEditingController homeNameController = TextEditingController();

   String generateRandomString (int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  void postToFirestoreHomeInfo(HomeModel homeModel) async{
    await _firebaseFirestore
        .collection("Homes")
        .doc(homeModel.home_id)
        .set(homeModel.toMap());
  }

  void updateToFirestoreHomeIdForUser(String uid, String home_id){
    CollectionReference userRef = FirebaseFirestore.instance.collection('users');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(userRef.doc(uid), {'home_id' : home_id});
    batch.commit();
  }

  late String homeName = "homeName";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: Icon(Icons.home, size: 50),
          ),
        ),
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller : homeNameController,
                    decoration: InputDecoration(
                      labelText: "Home Name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      border: UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  Divider(
                    height: 30,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      backgroundColor: HexColor('#00BFB2'),
                    ),
                    onPressed: () {
                      var home_id = generateRandomString(8);
                      HomeModel homeModel = HomeModel(home_id, homeNameController.text);
                      postToFirestoreHomeInfo(homeModel);
                      updateToFirestoreHomeIdForUser(widget.uid.toString(), home_id);
                      Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(builder: (context) => Home(email: widget.email.toString())),
                              (route) => false);

                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1.5,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
