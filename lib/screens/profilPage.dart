// ignore_for_file: file_names, unused_field, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_harcama_app/services/reviews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfilPage extends StatefulWidget {
  String email;
  ProfilPage({required this.email});
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}



class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('#00BFB2'),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          SizedBox(
            width: 50,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: Body(
        email: widget.email,
      ),
    );
  }
}

class Body extends StatefulWidget {
  String? email;
  Body({this.email});
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  late String uid;

  @override
  void postToFirestoreUpdateUserInfo() {
    CollectionReference userRef = FirebaseFirestore.instance.collection('users');
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(userRef.doc(uid), {'firstName' : nameController.text.toString(), 'secondName' : surnameController.text.toString()});
    batch.commit();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: widget.email.toString())
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) {
            return Text("Some error");
          } else if (querySnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final info = querySnapshot.data!.docs;
            nameController.text = info[0]['firstName'].toString();
            surnameController.text = info[0]['secondName'].toString();
            uid = info[0]['uid'].toString();
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 125,
                    width: 125,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profil.jpg"),
                        ),
                        Positioned(
                          right: -12,
                          bottom: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF5F6F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.white),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {},
                              child:
                                  SvgPicture.asset("assets/icons/camera.svg"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 50,
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
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: nameController.text,
                              labelText: "Name",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                          TextField(
                            controller: surnameController,
                            decoration: InputDecoration(
                              hintText: surnameController.text,
                              labelText: "Surname",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                          TextField(
                            enabled :false,
                            decoration: InputDecoration(
                              hintText: widget.email,
                              labelText: 'Email',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              border: UnderlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Divider(
                            height: 70,
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
                              setState(() {
                                postToFirestoreUpdateUserInfo();
                              });
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
                ),
              ],
            );
          }
        });
  }
}
