//this class is used as a Model class of the Todo Cards

class Todomodel {
  int id;
  String title;
  String description;
  String date;
  bool iscompletedcheck;

  Todomodel({
    this.id = 0,
    required this.date,
    required this.description,
    required this.title,
    required this.iscompletedcheck,
  });

  Map<String, dynamic> inserttoMap() {
    return {
      "title": title,
      "description": description,
      "date": date,
      "iscompletedcheck": iscompletedcheck ? 1 : 0,
    };
  }

  Map<String, dynamic> updatetoMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "iscompletedcheck": iscompletedcheck ? 1 : 0,
    };
  }
}
