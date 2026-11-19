class NoteModel {
  int? id;
  String title;
  String description;
  String date;
  String? imagePath;

  NoteModel({this.id, required this.title, required this.description, required this.date, this.imagePath});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description, 'date': date, 'imagePath': imagePath};
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'], title: map['title'], description: map['description'], 
      date: map['date'], imagePath: map['imagePath']
    );
  }
}
