// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettleUpPage extends StatefulWidget {
  String home_id;
  SettleUpPage({required this.home_id, Key? key}) : super(key: key);

  @override
  _SettleUpPageState createState() => _SettleUpPageState();
}

class _SettleUpPageState extends State<SettleUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settle Up'),
        centerTitle: true,
        backgroundColor: const Color(0xff00BFB2),
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Debts')
              .where('home_id', isEqualTo: widget.home_id.toString())
              .snapshots(),
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
                      '${list[index]['fromWho']} owes ${list[index]['toWho']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Text('Amount: ${list[index]['cost']}'),
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
