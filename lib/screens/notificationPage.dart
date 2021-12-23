// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationPage extends StatefulWidget {
  String email;
  String homeId;
  NotificationPage({required this.email, required this.homeId});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('#00BFB2'),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Body(
        homeId: widget.homeId,
        email: widget.email,
      )),
    );
  }
}

class Body extends StatefulWidget {
  String? homeId;
  String? email;
  Body({this.homeId, this.email});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Expenses').where('home_id', isEqualTo: widget.homeId.toString()).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> querySnapshot) {             
            if (querySnapshot.hasError) {
              return Text("Some Error");
            } else if (querySnapshot.connectionState ==
                ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              final list = querySnapshot.data!.docs;
              return ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  return ListTile(           
                    leading: Icon(Icons.notifications),
                    title: Text(
                      '${list[index]['user_id']} kişisinden harcama!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Text('${list[index]['description']} için ${list[index]['cost']} TL harcama yaptı'),
                    onTap: () {},
                    enabled: false,
                  );
                },
                
              );
            }
          }),
    );
  }
}
