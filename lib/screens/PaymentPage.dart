// ignore_for_file: file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_harcama_app/model/Expenses.dart';
import 'package:flutter_harcama_app/model/Debts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentPage extends StatefulWidget {
  String email;
  String home_id;
  PaymentPage({Key? key, required this.email, required this.home_id})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var howMuchController = TextEditingController();

  bool personSelected = false;
  var personSelectedList = <bool>[];
  String selectedUserMail = "";
  bool personSelected2 = false;
  var personSelectedList2 = <bool>[];
  String selectedUserMail2 = "";
  String selectedUserName = "";
  String selectedUserName2 = "";

  var moneyMapList = <
      Map<dynamic,
          dynamic>>[]; // seçilmeyen kullanılar için moneyState durumları, yani borçlular .
  var selectedUserMoneyState = "0";
  var selecteduid = "";
  var selectedUserMoneyState2 = "0";
  var selecteduid2 = "";
  final _formKey = GlobalKey<FormState>();

  /// Ad ve soyadın bas harflerini dondurur .
  String convertToNameAndSurname(String firstName, String secondName) {
    var firstLetterName = firstName.toUpperCase().trim().split("")[0];
    var firstLetterSurName = secondName.toUpperCase().trim().split("")[0];
    return firstLetterName + firstLetterSurName;
  }

  /// Verilen array'in icini false ile doldurur .
  void fillFalseList(List<bool> list, index) {
    if (list.length < index) {
      for (int i = 0; i < index; i++) {
        list.add(false);
      }
    }
  }

  /// random string olusturur .
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  /// Borçlu olanları borç tablosuna ekler.
  void postToFirestoreDebtsInfo(String cost, WriteBatch batch, String home_id) {
    double debt = double.parse(cost);
    CollectionReference debts = _firebaseFirestore.collection('Debts');
    //WriteBatch batch = _firebaseFirestore.batch();

    var debt_id = generateRandomString(30);
    var debtModel =
        Debts(debt, selectedUserMail, selectedUserMail2, debt_id, home_id);
    batch.set(debts.doc(debt_id), debtModel.toMap());

    //batch.commit();
  }

  /// para durumunu günceller .
  void postToFirestoreUpdateMoneyState(
      int userNumber, String cost, WriteBatch batch) {
    CollectionReference users = _firebaseFirestore.collection('users');
    //WriteBatch batch = _firebaseFirestore.batch();
    // borçlular için ...
    for (int i = 0; i < moneyMapList.length; i++) {
      moneyMapList[i].forEach((uid, moneyState) {
        print(uid + moneyState.toString());
        double debtUserMoneyState = moneyState - (double.parse(cost));
        batch.update(users.doc(uid), {"moneyState": debtUserMoneyState});
      });

      // ödeme yapan kişi için ...
      double payingUserMoneyState =
          double.parse(selectedUserMoneyState) + (double.parse(cost));
      batch
          .update(users.doc(selecteduid), {"moneyState": payingUserMoneyState});

      //batch.commit();
    }
  }

  /// userlarin mailine karsilik gelen moneyStateleri tutan bir listi doldurur .
  void getMoneyState(List<DocumentSnapshot> listOfDocumentSnapForUsers) {
    moneyMapList.clear();
    for (int i = 0; i < listOfDocumentSnapForUsers.length; i++) {
      var email = listOfDocumentSnapForUsers[i].get('email');
      var uid = listOfDocumentSnapForUsers[i].get('uid');
      if (email == selectedUserMail2) {
        var moneyState = listOfDocumentSnapForUsers[i].get('moneyState');
        moneyMapList.add({uid: moneyState});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef = _firebaseFirestore.collection("users");
    howMuchController.text = '0';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00BFB2),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Center(child: const Text("Cost Details")),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              usersRef.where("home_id", isEqualTo: widget.home_id).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("dfsfsdf" + widget.home_id);
            if (snapshot.hasData) {
              List<DocumentSnapshot> listOfDocumentSnapForUsers =
                  snapshot.data!.docs;
              //print(UserModel.fromMap(listOfDocumentSnapForUsers[0]).toString());
              fillFalseList(
                  personSelectedList, listOfDocumentSnapForUsers.length);
              fillFalseList(
                  personSelectedList2, listOfDocumentSnapForUsers.length);

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
                                  itemCount: listOfDocumentSnapForUsers.length,
                                  itemBuilder: (context, index) {
                                    var user =
                                        listOfDocumentSnapForUsers[index];
                                    var firstName =
                                        listOfDocumentSnapForUsers[index]
                                            .get('firstName');
                                    var secondName =
                                        listOfDocumentSnapForUsers[index]
                                            .get('secondName');
                                    var whoPaidText = convertToNameAndSurname(
                                        firstName, secondName);

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
                                            selectedUserMail =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('email');
                                            selectedUserName =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('firstName');
                                            selectedUserMoneyState =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('moneyState')
                                                    .toString();
                                            selecteduid =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('uid');
                                          } else {
                                            personSelectedList[index] = false;
                                            selectedUserMail = "";
                                            selectedUserMoneyState = "";
                                            selecteduid = "";
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
                                                  child: Text(whoPaidText,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTitle("To Who?"),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listOfDocumentSnapForUsers.length,
                                  itemBuilder: (context, index) {
                                    var user =
                                        listOfDocumentSnapForUsers[index];
                                    var firstName =
                                        listOfDocumentSnapForUsers[index]
                                            .get('firstName');
                                    var secondName =
                                        listOfDocumentSnapForUsers[index]
                                            .get('secondName');
                                    var whoPaidText = convertToNameAndSurname(
                                        firstName, secondName);

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (!personSelectedList2[index]) {
                                            personSelectedList2.fillRange(
                                                0,
                                                personSelectedList2!.length,
                                                false);
                                          }
                                          if (personSelectedList2[index] ==
                                              false) {
                                            personSelectedList2[index] = true;
                                            selectedUserMail2 =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('email');
                                            selectedUserName2 =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('firstName');
                                            selectedUserMoneyState2 =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('moneyState')
                                                    .toString();
                                            selecteduid2 =
                                                listOfDocumentSnapForUsers[
                                                        index]
                                                    .get('uid');
                                          } else {
                                            personSelectedList2[index] = false;
                                            selectedUserMail2 = "";
                                            selectedUserMoneyState2 = "";
                                            selecteduid2 = "";
                                          }
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: personSelectedList2[
                                                        index]
                                                    ? const Color(0xFF00BFB2)
                                                    : const Color(0xFFE0ECF8)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Center(
                                                  child: Text(whoPaidText,
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
                              buildTitle(selectedUserName),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // part1
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Current Balance"),
                                    ],
                                  ),
                                  // part2
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle(selectedUserMoneyState),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // part1
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("After Payment"),
                                    ],
                                  ),
                                  // part2
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle((double.parse(
                                                  selectedUserMoneyState) +
                                              (double.parse(
                                                  howMuchController.text)))
                                          .toString()),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              buildTitle(selectedUserName2),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // part1
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Current Balance"),
                                    ],
                                  ),
                                  // part2
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle(selectedUserMoneyState2),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // part1
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("After Payment"),
                                    ],
                                  ),
                                  // part2
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle((double.parse(
                                                  selectedUserMoneyState2) -
                                              (double.parse(
                                                  howMuchController.text)))
                                          .toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
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
                                if (!personSelectedList.contains(true)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Please, select a homemate"),
                                  ));
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  WriteBatch batch = _firebaseFirestore.batch();

                                  postToFirestoreDebtsInfo(
                                      howMuchController.text,
                                      batch,
                                      widget.home_id);
                                  getMoneyState(listOfDocumentSnapForUsers);
                                  postToFirestoreUpdateMoneyState(
                                      1, howMuchController.text, batch);
                                  batch.commit();
                                  Fluttertoast.showToast(
                                      msg: "Product added is successfully ...");
                                  /*setState(() {
                                    howMuchController.text = "";
                                    whatWasItController.text = "";
                                    dateController.text = "";
                                  });*/
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
