import 'dart:io';
import '../lib/models/note.dart';
import '../lib/servies/note_rep.dart'; // Проверь, чтобы папка называлась именно 'servies


void main() {
  // Важно: тип переменной Rep (интерфейс), а реализация Repository
  final Rep repo = Repository(); 
  bool isRunning = true;

  // Автоматически включаем поддержку UTF-8 в консоли Windows
  
  while (isRunning) {
    print('\n--- МЕНЮ (ПОФАЙЛОВОЕ ХРАНЕНИЕ) ---');
    print('1. Все заметки | 2. Добавить | 3. Удалить | 4. Поиск по ID | 5. Сортировка | 6. Выход');
    stdout.write('Выбор: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _showNotes(repo.all()); // Вызов нового метода all()
        break;
      case '2':
        _addNoteUI(repo);
        break;
      case '3':
        _deleteNoteUI(repo);
        break;
      case '4':
        _findNoteUI(repo);
        break;
      case '5':
        _sortUI(repo);
        break;
      case '6':
        isRunning = false;
        break;
    }
  }
}

void _showNotes(List<Note> notes) {
  if (notes.isEmpty) return print('Пусто.');
  for (var n in notes) {
    print('[ID: ${n.id}] ${n.title}');
  }
}

void _addNoteUI(Rep repo) {
  stdout.write('ID: ');
  int id = int.parse(stdin.readLineSync() ?? '0');
  stdout.write('Заголовок: ');
  String title = stdin.readLineSync() ?? '';
  
  // Создаем и сразу сохраняем в отдельный файл через repo.add()
  repo.add(Note(id, title, 'Текст', DateTime.now(), false, []));
}

void _deleteNoteUI(Rep repo) {
  stdout.write('ID для удаления: ');
  int id = int.parse(stdin.readLineSync() ?? '0');
  repo.del(id); // Вызов del() удалит физический файл
}

void _findNoteUI(Rep repo) {
  stdout.write('ID для поиска: ');
  int id = int.parse(stdin.readLineSync() ?? '0');
  final note = repo.findId(id);
  if (note != null) print('Найдено: ${note.title}');
}

void _sortUI(Rep repo) {
  print('1. По дате | 2. По алфавиту');
  final s = stdin.readLineSync();
  if (s == '1') _showNotes(repo.sortdata());
  if (s == '2') _showNotes(repo.sorttitle());
}
