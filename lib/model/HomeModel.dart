// ignore_for_file: file_names

class HomeModel {
  String home_id;
  String home_name;

  HomeModel(this.home_id, this.home_name);

  //veri yollama
  Map<String, dynamic> toMap() {
    return {
      'home_id': home_id,
      'home_name': home_name,
    };
  }

}