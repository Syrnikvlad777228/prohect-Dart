class Note {
  // Приватные поля
  int _id;
  String _title;
  String _content;
  DateTime _createdAt;
  bool _isFavorite;
  List<String> _tags;

  // Конструктор
  Note(
    this._id,
    this._title,
    this._content,
    this._createdAt,
    this._isFavorite,
    this._tags,
  );

  // Геттеры для доступа к данным
  int get id => _id;
  String get title => _title;
  String get content => _content;
  DateTime get createdAt => _createdAt;
  bool get isFavorite => _isFavorite;
  List<String> get tags => _tags;

  // Сеттеры (позволяют менять данные)
  set title(String value) => _title = value;
  set content(String value) => _content = value;
  set isFavorite(bool value) => _isFavorite = value;
  set tags(List<String> value) => _tags = value;

  //Сериализация: превращаем объект в Map для JSON
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

  //Десериализация: создаем объект из Map (при чтении из файла)
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