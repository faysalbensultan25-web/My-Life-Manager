class CategoryModel {
  int? id;
  String name;
  String type; // 'Income' অথবা 'Expense'
  String iconCode;
  int colorCode;

  CategoryModel({this.id, required this.name, required this.type, required this.iconCode, required this.colorCode});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type, 'iconCode': iconCode, 'colorCode': colorCode};
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'], name: map['name'], type: map['type'], 
      iconCode: map['iconCode'], colorCode: map['colorCode']
    );
  }
}
