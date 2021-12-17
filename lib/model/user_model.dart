class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? home_id;
  double? moneyState;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.home_id = '0',
      this.moneyState = 0});

  //veriyi çekme
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        home_id: map['home_id'],
        moneyState: map['moneyState']);
  }

  //veri yollama
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'home_id': home_id,
      'moneyState': moneyState
    };
  }
}

