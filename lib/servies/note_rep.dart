import '../models/note.dart';
import '../utils/file_helper.dart';

class NoteRepository {
  // Инкапсуляция: приватный список заметок
  final List<Note> _notes = [];

  NoteRepository() {
    _load();
  }

  // --- Основные методы управления  ---

  //Добавление заметки
  void addNote(Note note) {
    _notes.add(note);
    _save(); // Синхронное сохранение после добавления
    print('Система: Заметка с ID ${note.id} успешно добавлена.');
  }

  //Удаление заметки по ID
  bool deleteNote(int id) {
    int initialLength = _notes.length;
    _notes.removeWhere((n) => n.id == id);
    
    if (_notes.length < initialLength) {
      _save(); // Сохраняем обновленный список
      return true;
    }
    return false;
  }

  //Обновление существующей заметки
  bool updateNote(int id, {String? title, String? content, bool? isFavorite}) {
    try {
      final note = _notes.firstWhere((n) => n.id == id);
      
      if (title != null) note.title = title;
      if (content != null) note.content = content;
      if (isFavorite != null) note.isFavorite = isFavorite;
      
      _save(); // Сохраняем изменения
      return true;
    } catch (e) {
      return false; // Если заметка не найдена
    }
  }

  // --- Методы поиска и получения данных ---

  // Поиск по ID 
  Note? findById(int id) {
    for (var note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  //Геттер для получения всех заметок 
  List<Note> get allNotes => List.unmodifiable(_notes);

  // --- Внутренние методы для работы с файлами (Синхронно) ---

  void _save() {
    final List<Map<String, dynamic>> jsonData = _notes.map((n) => n.toJson()).toList();
    FileHelper.saveNotes(jsonData);
  }

  void _load() {
    final List<dynamic> savedData = FileHelper.loadNotes();
    _notes.clear();
    for (var item in savedData) {
      // Превращаем Map обратно в объект Note через именованный конструктор
      _notes.add(Note.fromJson(item as Map<String, dynamic>));
    }
  }
  //--- Теги ---
  List<Note> filterByTag(String tag) {
    // поиск тега с нижним регистром 
    return _notes.where((note) => 
      note.tags.any((t) => t.toLowerCase() == tag.toLowerCase())
    ).toList();
  }

  // По дате создания (свежие сверху)
  void sortByDate({bool ascending = false}) {
    _notes.sort((a, b) {
      return ascending 
          ? a.createdAt.compareTo(b.createdAt) 
          : b.createdAt.compareTo(a.createdAt);
    });
    _save(); // Сохраняем порядок в файл
    print('Система: Заметки отсортированы по дате.');
  }

  // По названию (в алфавитном порядке)
  void sortByTitle({bool ascending = true}) {
    _notes.sort((a, b) {
      // Сравниваем строки в нижнем регистре для корректной сортировки
      return ascending 
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
    _save(); // Сохраняем порядок в файл
    print('Система: Заметки отсортированы по названию.');
  }
}
