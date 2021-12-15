// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_harcama_app/screens/AddProduct.dart';
import 'package:flutter_harcama_app/screens/PaymentPage.dart';
import 'package:flutter_harcama_app/screens/notificationPage.dart';
import 'package:flutter_harcama_app/screens/profilPage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  const Align(
                    alignment: Alignment(-1, 0),
                    child: Text(
                      'USERNAME',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilPage()));
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
                        builder: (context) => NotificationPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text(
                'Spendings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => Spendings()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Log Out',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => Notifications()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ACASA"),
        backgroundColor: const Color(0xff00BFB2),
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                //  Navigator.push(
                //      context,
                //      MaterialPageRoute(
                //          builder: (context) => SettleUpScreen()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.verified,
                  size: 40,
                  color: Color(0xff00BFB2),
                ),
                title: Text(
                  'SETTLE UP',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff00BFB2),
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Color(0xff00BFB2),
        child: Icon(Icons.add),
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.send, color: Color(0xff00BFB2)),
              label: 'Record a payment',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentPage()));
              }),
          SpeedDialChild(
              child: const Icon(Icons.money, color: Color(0xff00BFB2)),
              label: 'Track a cost',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              }),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
