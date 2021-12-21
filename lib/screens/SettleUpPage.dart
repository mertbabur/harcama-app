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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Debts').where('home_id', isEqualTo: widget.home_id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('Debts')
                          .get()
                          .then((value) {
                        for (var element in value.docs) {
                          FirebaseFirestore.instance
                              .collection('Debts')
                              .doc(element.id)
                              .delete();
                        }
                      });
                    },
                  ),
                  leading: Icon(Icons.attach_money),
                  title: Text(
                      '${document['fromWho']} owes ${document['toWho']} ${document['cost']}'),
                );
              }).toList(),
            );
          }),
    );
  }
}
