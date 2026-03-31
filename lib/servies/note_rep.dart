import '../models/note.dart';
import '../utils/file_helper.dart';

class NoteRepository {
  final List<Note> _notes = [];

  NoteRepository() {
    _load();
  }

  void addNote(Note note) {
    _notes.add(note);
    _save(); 
    print('Система: Заметка с ID ${note.id} успешно добавлена.');
  }
  bool deleteNote(int id) {
    int initialLength = _notes.length;
    _notes.removeWhere((n) => n.id == id);
    
    if (_notes.length < initialLength) {
      _save(); 
      return true;
    }
    return false;
  }

  bool updateNote(int id, {String? title, String? content, bool? isFavorite}) {
    try {
      final note = _notes.firstWhere((n) => n.id == id);
      
      if (title != null) note.title = title;
      if (content != null) note.content = content;
      if (isFavorite != null) note.isFavorite = isFavorite;
      
      _save(); 
      return true;
    } catch (e) {
      return false; 
    }
  }

  // Поиск по ид
  Note? findById(int id) {
    for (var note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  List<Note> get allNotes => List.unmodifiable(_notes);

  void _save() {
    final List<Map<String, dynamic>> jsonData = _notes.map((n) => n.toJson()).toList();
    FileHelper.saveNotes(jsonData);
  }

  void _load() {
    final List<dynamic> savedData = FileHelper.loadNotes();
    _notes.clear();
    for (var item in savedData) {
      _notes.add(Note.fromJson(item as Map<String, dynamic>));
    }
  }
  List<Note> filterByTag(String tag) {
    return _notes.where((note) => 
      note.tags.any((t) => t.toLowerCase() == tag.toLowerCase())
    ).toList();
  }

  void sortByDate({bool ascending = false}) {
    _notes.sort((a, b) {
      return ascending 
          ? a.createdAt.compareTo(b.createdAt) 
          : b.createdAt.compareTo(a.createdAt);
    });
    _save(); 
    print('Система: Заметки отсортированы по дате.');
  }

  void sortByTitle({bool ascending = true}) {
    _notes.sort((a, b) {
      return ascending 
          ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
          : b.title.toLowerCase().compareTo(a.title.toLowerCase());
    });
    _save(); 
    print('Система: Заметки отсортированы по названию.');
  }
}
