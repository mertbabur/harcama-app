import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
        actions: [
          SizedBox(
            width: 50,
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String homeName = "homeName";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListView.separated(
          itemCount: 10,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Harcama',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              subtitle: Text('Harcama yapıldı'),
              onTap: () {},
              enabled: false,
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
      ],
    );
  }
}