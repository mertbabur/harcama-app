// ignore_for_file: file_names

import 'package:flutter/material.dart';


//import 'Person.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var howMuchController = TextEditingController();
  var whatWasItController = TextEditingController();
  var dateController = TextEditingController();

  /*Future<List<Person>> getAllPerson() async {
    var personList = <Person>[];
    var p1 = Person(1, "MB");
    var p2 = Person(2, "BD");
    var p3 = Person(3, "FC");

    personList.add(p1);
    personList.add(p2);
    personList.add(p3);

    return personList;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00BFB2),
        title: Center(
         child: Row(
            children: [
              GestureDetector(child: Icon(Icons.arrow_back_ios, color: Colors.teal)),
              SizedBox(width: 100),
              Text("Make a payment", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // app bar


              //girdi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // part1
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle("From:"),
                      SizedBox(height: 10),
                      buildWhoButton("MB"),
                    ],
                  ),
                  // part2
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle("To:"),
                      SizedBox(height: 10),
                      buildWhoButton("MB"),

                    ],
                  ),
                ],
              ),

              // who paid
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle("How Much?"),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: TextField(
                      controller: howMuchController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "t0,00",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle("You"),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // part1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Current Balance"),


                        ],
                      ),
                      // part2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("x5"),


                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // part1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Current Balance"),


                        ],
                      ),
                      // part2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("x5"),


                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildTitle("You"),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // part1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Current Balance"),


                        ],
                      ),
                      // part2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("x5"),


                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // part1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Current Balance"),


                        ],
                      ),
                      // part2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("x5"),


                        ],
                      ),
                    ],
                  ),

                ],
              ),
              SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  ),
                  onPressed: () {
                    print("tik");
                  },
                ),
              ),



            ],
          ),
        ),

      ),
    );
  }
}



Widget buildTitle(String title){
  return Text(title, style: TextStyle(color: Colors.grey),);
}

Widget buildWhoButton(String title){
  return GestureDetector(
    onTap: () {
      print("sdfsdfsdf");
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 19, vertical: 22),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE0ECF8)),
      child: Text(title),
    ),
  );
}
