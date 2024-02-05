class DataModel {
  String? id;
  String? name;
  int? age;
  String? position;
  String? salary;

  DataModel({this.id, this.name, this.age, this.salary, this.position});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['_id'] ?? 'No ID',
      name: json['name'] ?? 'No Name',
      age: json['age'] != null ? int.parse(json['age'].toString()) : null,
      salary: json['salary'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'salary': salary,
      'position': position,
    };
  }
}
