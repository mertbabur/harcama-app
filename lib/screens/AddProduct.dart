// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../model/Person.dart';

class AddProduct extends StatefulWidget {
  String email;
  AddProduct({Key? key, required this.email}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var howMuchController = TextEditingController();
  var whatWasItController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  bool personSelected = false;
  var personSelectedList = <bool>[];
  final _formKey = GlobalKey<FormState>();

  Future<List<Person>> getAllPerson() async {
    var personList = <Person>[];
    var p1 = Person(1, "MB");
    var p2 = Person(1, "MB");
    var p3 = Person(1, "MB");
    var p4 = Person(1, "MB");
    var p5 = Person(1, "MB");
    var p6 = Person(1, "MB");
    var p7 = Person(2, "BD");
    var p8 = Person(3, "FC");

    personList.add(p1);
    personList.add(p2);
    personList.add(p4);
    personList.add(p5);
    personList.add(p6);
    personList.add(p7);
    personList.add(p8);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);
    personSelectedList.add(false);

    return personList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFB2),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Center(child: const Text("Cost Details")),
      ),
      body: FutureBuilder<List<Person>>(
          future: getAllPerson(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var personList = snapshot.data;
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // part1
                              buildTextField("How Much?", howMuchController,
                                  TextInputType.number, "t0,00", 150),
                              // part2
                              buildTextField(
                                  "What was it?",
                                  whatWasItController,
                                  TextInputType.text,
                                  "",
                                  150),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitle("Who paid?"),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: personList!.length,
                                  itemBuilder: (context, index) {
                                    var person = personList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (!personSelectedList[index]) {
                                            personSelectedList.fillRange(
                                                0,
                                                personSelectedList!.length,
                                                false);
                                          }
                                          if (personSelectedList[index] ==
                                              false) {
                                            personSelectedList[index] = true;
                                          } else {
                                            personSelectedList[index] = false;
                                          }
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: personSelectedList[index]
                                                    ? const Color(0xFF00BFB2)
                                                    : const Color(0xFFE0ECF8)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Center(
                                                  child: Text(person.title,
                                                      style: const TextStyle(
                                                          fontSize: 15))),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitle("Date"),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF00BFB2)),
                                    ),
                                  ),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050),
                                    ).then((value) {
                                      setState(() {
                                        dateController.text =
                                            "${value!.day}/${value!.month}/${value!.year}";
                                      });
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter info';
                                    }
                                    return null;
                                  },
                                ),
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
                                  primary: Color(0xFF00BFB2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              onPressed: () {
                                if(!personSelectedList.contains(true)){
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Please, select a homemate"),
                                  ));
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  print("tik" +
                                      dateController.text +
                                      " " +
                                      whatWasItController.text +
                                      " " +
                                      howMuchController.text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Text("sdfsdef");
            }
          }),
    );
  }
}

Widget buildTitle(String title) {
  return Text(
    title,
    style: TextStyle(color: Colors.grey),
  );
}

Widget buildTextField(String title, TextEditingController controller,
    TextInputType keyboardType, String hintText, double textFieldWidth) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildTitle(title),
      SizedBox(
        width: textFieldWidth,
        height: 50,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00BFB2)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter info';
            }
            return null;
          },
        ),
      ),
    ],
  );
}
