import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CreateHomePage extends StatefulWidget {
  const CreateHomePage({Key? key}) : super(key: key);

  @override
  _CreateHomePageState createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<CreateHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: HexColor('#00BFB2'),
        title: Center(
          child: Text(
            'Create New Home',
            style: TextStyle(color: Colors.white),
          ),
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
                    decoration: InputDecoration(
                      hintText: homeName,
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
                    onPressed: () {},
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
