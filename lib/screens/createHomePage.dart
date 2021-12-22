import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
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

  void postToFirestoreHomeInfo(String id, String homeName) async{
    await _firebaseFirestore
        .collection("Home")
        .doc(id)
        .set(homeName.toMap());
  }

  late String homeName = "homeName";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 125,
            width: 125,
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
                      postToFirestoreHomeInfo(home_id,homeNameController.text);
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
