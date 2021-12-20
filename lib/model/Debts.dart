// ignore_for_file: file_names

class Debts {
  double cost;
  String fromWho;
  String toWho;
  String debt_id;
  String home_id;

  Debts(this.cost, this.fromWho, this.toWho, this.debt_id,
      this.home_id);

  //veri yollama
  Map<String, dynamic> toMap() {
    return {
      'cost': cost,
      'fromWho': fromWho,
      'toWho': toWho,
      'debt_id': debt_id,
      'home_id': home_id
    };
  }

}