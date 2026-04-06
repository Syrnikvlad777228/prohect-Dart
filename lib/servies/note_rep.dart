import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import '../models/note.dart';

// 1. Абстрактный класс (Интерфейс)
// Здесь перечислены все функции, которые должны быть в репозитории
abstract class Rep {
  void add(Note note);
  void del(int id);
  List<Note> all();
  void upd(Note note);
  Note? findId(int id);
  List<Note> findTag(String tag);
  List<Note> sortdata();
  List<Note> sorttitle();
}

// 2. Реализация репозитория
class Repository extends Rep {
  late final Directory _storageDir;

  Repository() {
    // Получаем путь к папке пользователя (C:\Users\Имя)
    final userHome = Platform.environment['USERPROFILE'] ?? Directory.current.path;
    
    // Собираем путь: Документы -> MyNotes (используем только английские буквы)
    final String pathToDocs = p.join(userHome, 'Documents', 'MyNotes');
    
    _storageDir = Directory(pathToDocs);
    
    // Создаем папку, если её еще нет
    if (!_storageDir.existsSync()) {
      _storageDir.createSync(recursive: true);
    }
  }

  // Внутренний метод для записи файла на диск
  void _saveToFile(Note note) {
    try {
      final filePath = p.join(_storageDir.path, '${note.id}.json');
      final file = File(filePath);
      final String jsonString = jsonEncode(note.toJson());
      file.writeAsStringSync(jsonString, encoding: utf8);
    } catch (e) {
      print('Ошибка при сохранении файла: $e');
    }
  }

  @override
  void add(Note note) {
    _saveToFile(note);
    print('Система: Заметка ${note.id} сохранена.');
  }

  @override
  void upd(Note note) {
    _saveToFile(note); // В пофайловой логике обновление — это перезапись
    print('Система: Заметка ${note.id} обновлена.');
  }

  @override
  void del(int id) {
    final file = File(p.join(_storageDir.path, '$id.json'));
    if (file.existsSync()) {
      file.deleteSync();
      print('Система: Файл заметки $id удален.');
    } else {
      print('Система: Файл не найден.');
    }
  }

  @override
  List<Note> all() {
    if (!_storageDir.existsSync()) return [];

    // Читаем все JSON файлы из папки и превращаем их в объекты Note
    return _storageDir
        .listSync()
        .whereType<File>()
        .where((f) => p.extension(f.path) == '.json')
        .map((f) {
          final content = f.readAsStringSync(encoding: utf8);
          return Note.fromJson(jsonDecode(content));
        })
        .toList();
  }

  @override
  Note? findId(int id) {
    final file = File(p.join(_storageDir.path, '$id.json'));
    if (file.existsSync()) {
      final content = file.readAsStringSync(encoding: utf8);
      return Note.fromJson(jsonDecode(content));
    }
    return null;
  }

  @override
  List<Note> findTag(String tag) {
    // Ищем заметки, у которых в списке тегов есть нужный нам
    return all().where((n) => n.tags.any((t) => t.toLowerCase() == tag.toLowerCase())).toList();
  }

  @override
  List<Note> sortdata() {
    final notes = all();
    // Сортировка: новые даты сверху
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  @override
  List<Note> sorttitle() {
    final notes = all();
    // Сортировка по алфавиту (без учета регистра)
    notes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return notes;
  }
}
