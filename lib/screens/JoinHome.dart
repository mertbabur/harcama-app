// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_harcama_app/screens/home.dart';
import 'package:hexcolor/hexcolor.dart';

class JoinHome extends StatefulWidget {
  String email;
  String uid;
  JoinHome({Key? key, required this.email, required this.uid}) : super(key: key);

  @override
  _JoinHomeState createState() => _JoinHomeState();
}

class _JoinHomeState extends State<JoinHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('#00BFB2'),
        title: const Text(
          'Join New Home',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
      ),
      body: Body(email : widget.email, uid: widget.uid),
    );
  }
}

class Body extends StatefulWidget {
  String email;
  String uid;
  Body({required this.email, required this.uid});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String homeName = "";
  final _formKey = GlobalKey<FormState>();
  var home_idController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  /// home_id gunceller .
  void postToFirestoreUpdateMoneyState(String uid, String home_id) {
    var users = _firebaseFirestore.collection('users');
    WriteBatch batch = _firebaseFirestore.batch();
    batch.update(users.doc(uid), {"home_id" : home_id});
    batch.commit();

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Home(email: widget.email)),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    print("join : " + widget.email + " " + widget.uid);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Center(
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
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter info';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Enter home id, please",
                        labelText: "Home ID",
                        floatingLabelBehavior: FloatingLabelBehavior.always,

                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      controller: home_idController,
                    ),
                    const Divider(
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
                        if (_formKey.currentState!.validate()) {
                          postToFirestoreUpdateMoneyState(widget.uid, home_idController.text.toString());
                        }
                      },
                      child: const Text(
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
            ),
          ],
        )
      ],
    );
  }
}
