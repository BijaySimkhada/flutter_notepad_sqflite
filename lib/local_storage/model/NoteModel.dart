class NoteModel{
  int id;
  String title;
  String content;
  String createdAt;
  String updatedAt;

  NoteModel(this.id, this.title, this.content, this.createdAt, this.updatedAt);

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}