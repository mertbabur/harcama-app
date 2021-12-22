// ignore_for_file: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_harcama_app/screens/JoinHome.dart';

import 'createHomePage.dart';

class ChooseScreen extends StatefulWidget {
  String email;
  String uid;

  ChooseScreen({Key? key, required this.email, required this.uid}) : super(key: key);

  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    print("choose : " + widget.email + " " + widget.uid);
    CollectionReference usersRef = _firebaseFirestore.collection("users");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFB2),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Center(child: const Text("Cost Details")),
      ),
      body: Center(
        child: Column(
          children :[
            SizedBox(height: 100,),
            Icon(Icons.home, color: Colors.black, size: 100,),
            SizedBox(height: 100,),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(builder: (context) => CreateHomePage(email: widget.email, uid: widget.uid)),
                              (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF00BFB2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text("Create Home")
                ),
              ),
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(builder: (context) => JoinHome(email: widget.email, uid: widget.uid)),
                              (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF00BFB2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text("Join Home")
                ),
              )
            ],
          ),
          ],
        ),
      ),
    );
  }
}


