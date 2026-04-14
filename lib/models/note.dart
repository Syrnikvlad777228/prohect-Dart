class Note {
  int id; 
  String title;
  String content;
  DateTime createdAt;
  bool isFavorite;
  List<String> tags;

  Note(this.id, this.title, this.content, this.createdAt, this.isFavorite, this.tags);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'isFavorite': isFavorite,
    'tags': tags,
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    json['id'],
    json['title'],
    json['content'],
    DateTime.parse(json['createdAt']),
    json['isFavorite'] ?? false,
    List<String>.from(json['tags'] ?? []),
  );
}
