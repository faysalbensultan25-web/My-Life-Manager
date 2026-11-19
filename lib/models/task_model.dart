class TaskModel {
  int? id;
  String title;
  String date;
  String priority; // 'High', 'Medium', 'Low'
  int isCompleted; // 0 = false, 1 = true

  TaskModel({this.id, required this.title, required this.date, required this.priority, this.isCompleted = 0});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'date': date, 'priority': priority, 'isCompleted': isCompleted};
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'], title: map['title'], date: map['date'], 
      priority: map['priority'], isCompleted: map['isCompleted']
    );
  }
}
