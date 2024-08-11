class NoteModel {
  String id;
  String title;
  String content;
  String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'userId': userId,
    };
  }
}
