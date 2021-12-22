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


class AddProduct extends StatefulWidget {
  String email;
  String home_id;
  AddProduct({Key? key, required this.email, required this.home_id}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var howMuchController = TextEditingController();
  var whatWasItController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  bool personSelected = false;
  var personSelectedList = <bool>[];
  String selectedUserMail = "";
  var notSelectedUserMail = <String>[];
  var moneyMapList = <Map<dynamic, dynamic>>[]; // seçilmeyen kullanılar için moneyState durumları, yani borçlular .
  var selectedUserMoneyState = "";
  var selecteduid = "";
  final _formKey = GlobalKey<FormState>();


  /// Ad ve soyadın bas harflerini dondurur .
  String convertToNameAndSurname(String firstName, String secondName) {
    var firstLetterName = firstName.toUpperCase().trim().split("")[0];
    var firstLetterSurName = secondName.toUpperCase().trim().split("")[0];
    return firstLetterName + firstLetterSurName;
  }

  /// Verilen array'in icini false ile doldurur .
  void fillFalseList(List<bool> list, index){
    if(list.length < index){
      for(int i = 0; i < index; i++) {
        list.add(false);
      }
    }
  }

  /// random string olusturur .
  String generateRandomString (int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  /// WhoPaiddeki tiklanmayan userlarin maillerini list'e atar .
  void fillNotSelectedUserMail (List<DocumentSnapshot> listOfDocumentSnapForUsers) {
    notSelectedUserMail.clear();
    for(int i = 0; i < listOfDocumentSnapForUsers.length; i++){
      var email = listOfDocumentSnapForUsers[i].get('email');
      if(email != selectedUserMail){
        notSelectedUserMail.add(email);
      }
    }
  }

  /// Expenses tablosuna gerekli bilgileri atar .
  void postToFirestoreExpensesInfo(String id, Expenses expenses) async{
    await _firebaseFirestore
        .collection("Expenses")
        .doc(id)
        .set(expenses.toMap());
  }

  /// Borçlu olanları borç tablosuna ekler.
  void postToFirestoreDebtsInfo(int userNumber, String cost, WriteBatch batch, String home_id) {
    double debt  = double.parse(cost) / userNumber;
    CollectionReference debts = _firebaseFirestore.collection('Debts');
    //WriteBatch batch = _firebaseFirestore.batch();
    for(int i = 0; i < notSelectedUserMail!.length; i++){
      var debt_id = generateRandomString(30);
      var debtModel = Debts(debt, notSelectedUserMail[i], widget.email, debt_id, home_id);
      batch.set(debts.doc(debt_id), debtModel.toMap());
    }
    //batch.commit();
  }

  /// para durumunu günceller .
  void postToFirestoreUpdateMoneyState(int userNumber, String cost, WriteBatch batch) {
    CollectionReference users = _firebaseFirestore.collection('users');
    //WriteBatch batch = _firebaseFirestore.batch();
    // borçlular için ...
    for (int i = 0; i < moneyMapList.length; i++) {
      moneyMapList[i].forEach((uid, moneyState) {
        print(uid + moneyState.toString());
        double debtUserMoneyState = moneyState - (double.parse(cost) / userNumber);
        batch.update(users.doc(uid), {"moneyState" : debtUserMoneyState});
      });

      // ödeme yapan kişi için ...
      double payingUserMoneyState = double.parse(selectedUserMoneyState) + ((double.parse(cost) / userNumber) * (userNumber - 1));
      batch.update(users.doc(selecteduid), {"moneyState" : payingUserMoneyState});

      //batch.commit();
    }
  }

  /// userlarin mailine karsilik gelen moneyStateleri tutan bir listi doldurur .
  void getMoneyState (List<DocumentSnapshot> listOfDocumentSnapForUsers) {
    moneyMapList.clear();
    for(int i = 0; i < listOfDocumentSnapForUsers.length; i++){
      var email = listOfDocumentSnapForUsers[i].get('email');
      var uid = listOfDocumentSnapForUsers[i].get('uid');
      if(email != selectedUserMail){
        var moneyState = listOfDocumentSnapForUsers[i].get('moneyState');
        moneyMapList.add({ uid : moneyState});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef = _firebaseFirestore.collection("users");
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color(0xFF00BFB2),
        elevation: 0.0,
        title: const Text("Cost Details", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: usersRef.where("home_id", isEqualTo: widget.home_id).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print("dfsfsdf" + widget.home_id);
            if (snapshot.hasData) {
              List<DocumentSnapshot> listOfDocumentSnapForUsers = snapshot.data!.docs;
              //print(UserModel.fromMap(listOfDocumentSnapForUsers[0]).toString());
              fillFalseList(personSelectedList, listOfDocumentSnapForUsers.length);

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
                                  itemCount: listOfDocumentSnapForUsers.length,
                                  itemBuilder: (context, index) {
                                    var user = listOfDocumentSnapForUsers[index];
                                    var firstName = listOfDocumentSnapForUsers[index].get('firstName');
                                    var secondName = listOfDocumentSnapForUsers[index].get('secondName');
                                    var whoPaidText = convertToNameAndSurname(firstName, secondName);

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
                                            selectedUserMail = listOfDocumentSnapForUsers[index].get('email');
                                            selectedUserMoneyState = listOfDocumentSnapForUsers[index].get('moneyState').toString();
                                            selecteduid = listOfDocumentSnapForUsers[index].get('uid');
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
                              child: Text("Continue", style: TextStyle(color: Colors.white)),
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
                                  WriteBatch batch = _firebaseFirestore.batch();
                                  var productId = generateRandomString(30);
                                  var expenses = Expenses(productId, howMuchController.text, whatWasItController.text, widget.home_id, selectedUserMail, dateController.text);
                                  fillNotSelectedUserMail(listOfDocumentSnapForUsers);
                                  postToFirestoreExpensesInfo(productId, expenses);
                                  postToFirestoreDebtsInfo(listOfDocumentSnapForUsers!.length, howMuchController.text, batch, widget.home_id);
                                  getMoneyState(listOfDocumentSnapForUsers);
                                  postToFirestoreUpdateMoneyState(listOfDocumentSnapForUsers!.length, howMuchController.text, batch);
                                  batch.commit();
                                  Fluttertoast.showToast(msg: "Product added is successfully ...");
                                  setState(() {
                                    howMuchController.text = "";
                                    whatWasItController.text = "";
                                    dateController.text = "";
                                  });

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
