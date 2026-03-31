class Note {
  int _id;
  String _title;
  String _content;
  DateTime _createdAt;
  bool _isFavorite;
  List<String> _tags;

  Note(
    this._id,
    this._title,
    this._content,
    this._createdAt,
    this._isFavorite,
    this._tags,
  );

  int get id => _id;
  String get title => _title;
  String get content => _content;
  DateTime get createdAt => _createdAt;
  bool get isFavorite => _isFavorite;
  List<String> get tags => _tags;

  set title(String value) => _title = value;
  set content(String value) => _content = value;
  set isFavorite(bool value) => _isFavorite = value;
  set tags(List<String> value) => _tags = value;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'title': _title,
      'content': _content,
      'createdAt': _createdAt.toIso8601String(), // Дату в строку
      'isFavorite': _isFavorite,
      'tags': _tags,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      json['id'],
      json['title'],
      json['content'],
      DateTime.parse(json['createdAt']), // Строку в дату
      json['isFavorite'] ?? false,
      List<String>.from(json['tags'] ?? []),
    );
  }
}
