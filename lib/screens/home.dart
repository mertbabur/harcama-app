// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_harcama_app/model/chart_user_model.dart';
import 'package:flutter_harcama_app/screens/AddProduct.dart';
import 'package:flutter_harcama_app/screens/PaymentPage.dart';
import 'package:flutter_harcama_app/screens/notificationPage.dart';
import 'package:flutter_harcama_app/screens/profilPage.dart';
import 'package:flutter_harcama_app/screens/welcome.dart';
import 'package:flutter_harcama_app/services/reviews.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'SettleUpPage.dart';

class Home extends StatefulWidget {
  String email;
  Home({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var reviews;
  var home_id;
  var firstName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<charts.Series<ChartUserModel, String>>? _seriesBarData;
  late List<ChartUserModel> myData;
  _generateData(myData) {
    _seriesBarData = <charts.Series<ChartUserModel, String>>[];
    _seriesBarData!.add(charts.Series(
        domainFn: (ChartUserModel chartUserModel, _) =>
            chartUserModel.firstName.toString(),
        measureFn: (ChartUserModel chartUserModel, _) =>
            chartUserModel.moneyState,
        colorFn: (ChartUserModel chartUserModel, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff00BFB2)),
        id: 'UserModel',
        data: myData,
        labelAccessorFn: (ChartUserModel row, _) => '${row.moneyState}'));
  }

  @override
  void initState() {
    super.initState();
    ReviewService()
        .getLatestReview(widget.email.toString())
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        reviews = docs.docs[0].data();
        setState(() {
          home_id = reviews['home_id'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff00BFB2),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: const Alignment(-1, 0),
                    child: CircleAvatar(
                      child: Image.asset('assets/images/user.png'),
                      backgroundColor: const Color(0xff00BFB2),
                      radius: 30.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      widget.email,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(email: widget.email)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilPage(email: widget.email, home_id: home_id,)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text(
                'Notifications',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage(
                            email: widget.email, homeId: home_id)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                        (route) => false);

                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => Notifications()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("EXPENSE APP"),
        backgroundColor: const Color(0xff00BFB2),
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            child: _buildBody(context),
            height: 280,
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettleUpPage(
                            home_id: home_id,
                          )));
            },
            child: ListTile(
              leading: Icon(
                Icons.verified,
                color: Color(0xff00BFB2),
              ),
              title: Text(
                'SETTLE UP',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('home_id', isEqualTo: home_id.toString())
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
                        leading: Icon(Icons.monetization_on),
                        title: Text(
                          'Budget of ${list[index]['firstName']}: ${list[index]['moneyState']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        onTap: () {},
                        enabled: false,
                      );
                    },
                  );
                }
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50),
        color: Color(0xff00BFB2),
        shape: const CircularNotchedRectangle(),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Color(0xff00BFB2),
        child: Icon(Icons.add, color: Colors.white),
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.send, color: Color(0xff00BFB2)),
              label: 'Record a payment',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentPage(
                            email: widget.email, home_id: home_id.toString())));
              }),
          SpeedDialChild(
              child: const Icon(Icons.money, color: Color(0xff00BFB2)),
              label: 'Track a cost',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                        email: widget.email, home_id: home_id.toString()),
                  ),
                );
              }),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('home_id', isEqualTo: home_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ChartUserModel> chartUserModel = snapshot.data!.docs
              .map((documentSnapshot) => ChartUserModel.fromMap(
                  documentSnapshot.data() as Map<String, dynamic>))
              .toList();
          return _buildChart(context, chartUserModel);
        }
      },
    );
  }

  Widget _buildChart(
      BuildContext context, List<ChartUserModel> chartUserModel) {
    myData = chartUserModel;
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: charts.BarChart(
                _seriesBarData!,
                animate: true,
                animationDuration: Duration(seconds: 2),
                behaviors: [
                  charts.DatumLegend(
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
