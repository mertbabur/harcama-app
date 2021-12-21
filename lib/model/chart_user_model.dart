class ChartUserModel{
  final String firstName;
  final String secondName;
  final double moneyState;
  ChartUserModel({required this.firstName, required this.secondName, required this.moneyState});

  ChartUserModel.fromMap(Map<String, dynamic> map)
  :assert(map['firstName'] != null),
  assert(map['secondName'] != null),
  assert(map['moneyState'] != null),
    firstName = map['firstName'],
    secondName = map['secondName'],
    moneyState = map['moneyState'];

  

}