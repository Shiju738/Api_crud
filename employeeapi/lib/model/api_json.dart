class DataModel {
  String? id;
  String? name;
  int? age;
  String? position;
  String? salary;
  String? image;

  DataModel(
      {this.id, this.name, this.age, this.salary, this.position, this.image});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['_id'] ?? 'No ID',
      name: json['name'] ?? 'No Name',
      age: json['age'] != null ? int.parse(json['age'].toString()) : null,
      salary: json['salary'],
      position: json['position'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'salary': salary,
      'position': position,
      'image': image,
    };
  }
}
