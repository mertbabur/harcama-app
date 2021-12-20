// ignore_for_file: file_names

class Expenses {
  String productId;
  String cost;
  String description;
  String home_id;
  String user_id;
  String date;


  Expenses(this.productId, this.cost, this.description, this.home_id,
      this.user_id, this.date);

  //veri yollama
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'user_id': user_id,
      'description': description,
      'home_id': home_id,
      'cost': cost,
      'date': date
    };
  }

}