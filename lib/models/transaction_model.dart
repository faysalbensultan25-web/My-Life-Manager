class TransactionModel {
  int? id;
  double amount;
  String type; // 'Income' অথবা 'Expense'
  int categoryId;
  String date;
  String note;
  String? categoryName; // UI-তে দেখানোর জন্য
  String? categoryIcon;

  TransactionModel({
    this.id, required this.amount, required this.type, required this.categoryId, 
    required this.date, required this.note, this.categoryName, this.categoryIcon
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'amount': amount, 'type': type, 'categoryId': categoryId, 'date': date, 'note': note};
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'], amount: map['amount'], type: map['type'], 
      categoryId: map['categoryId'], date: map['date'], note: map['note'],
      categoryName: map['categoryName'], categoryIcon: map['categoryIcon'],
    );
  }
}
