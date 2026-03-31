import 'dart:io';
import '../lib/models/note.dart';
import '../lib/servies/note_rep.dart';

void main() {
  final repo = NoteRepository();
  bool isRunning = true;

  print('=== ПРИЛОЖЕНИЕ "ЗАМЕТКИ" (V1.0) ===(Избранное в разработке)');

  while (isRunning) {
    print('\n--- ГЛАВНОЕ МЕНЮ ---');
    print('1. Показать все заметки');
    print('2. Добавить заметку');
    print('3. Удалить заметку по ID');
    print('4. Найти заметку по ID');
    print('5. Редактировать заметку');
    print('6. Фильтр по тегам');
    print('7. Сортировка (Дата/Имя)');
    print('8. Выход');
    stdout.write('\nВыберите пункт (1-8): ');

    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        _showNotes(repo.allNotes);
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
        _editNoteUI(repo);
        break;
      case '6':
        _filterByTagUI(repo);
        break;
      case '7':
        _sortUI(repo);
        break;
      case '8':
        print('Завершение работы... До встречи!');
        isRunning = false;
        break;
      default:
        print('! Ошибка: выберите число от 1 до 8.');
    }
  }
}

void _showNotes(List<Note> notes) {
  if (notes.isEmpty) {
    print('\n[ Список заметок пуст ]');
    return;
  }
  print('\n--- СПИСОК ЗАМЕТОК ---');
  for (var n in notes) {
    print('[ID: ${n.id}] ${n.title} | Теги: ${n.tags.join(", ")} | Избранное: ${n.isFavorite ? "★" : "☆"}');
  }
}

void _addNoteUI(NoteRepository repo) {
  try {
    stdout.write('Введите ID (число): ');
    int id = int.parse(stdin.readLineSync() ?? '0');
    
    stdout.write('Заголовок: ');
    String title = stdin.readLineSync() ?? 'Без названия';
    
    stdout.write('Текст заметки: ');
    String content = stdin.readLineSync() ?? '';

    stdout.write('Введите теги через запятую: ');
    List<String> tags = (stdin.readLineSync() ?? '').split(',').map((e) => e.trim()).toList();

    final newNote = Note(id, title, content, DateTime.now(), false, tags);
    repo.addNote(newNote);
  } catch (e) {
    print('! Ошибка ввода: ID должен быть числом.');
  }
}

void _deleteNoteUI(NoteRepository repo) {
  stdout.write('Введите ID для удаления: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id != null) {
    if (repo.deleteNote(id)) {
      print('Заметка удалена.');
    } else {
      print('! Заметка с таким ID не найдена.');
    }
  }
}

void _findNoteUI(NoteRepository repo) {
  stdout.write('Введите ID для поиска: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  final note = id != null ? repo.findById(id) : null;
  
  if (note != null) {
    print('\nНайдена заметка:');
    print('Заголовок: ${note.title}');
    print('Текст: ${note.content}');
    print('Дата создания: ${note.createdAt}');
  } else {
    print('! Заметка не найдена.');
  }
}

void _filterByTagUI(NoteRepository repo) {
  stdout.write('Введите тег для фильтрации: ');
  String tag = stdin.readLineSync() ?? '';
  final filtered = repo.filterByTag(tag);
  _showNotes(filtered);
}

void _sortUI(NoteRepository repo) {
  print('1. Сортировать по дате (новые сверху)');
  print('2. Сортировать по алфавиту');
  final sortChoice = stdin.readLineSync();
  if (sortChoice == '1') repo.sortByDate();
  if (sortChoice == '2') repo.sortByTitle();
}

void _editNoteUI(NoteRepository repo) {
  stdout.write('Введите ID заметки для редактирования: ');
  int? id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) return;

  stdout.write('Новый заголовок (оставьте пустым, чтобы не менять): ');
  String? title = stdin.readLineSync();
  title = title?.isEmpty == true ? null : title;

  stdout.write('Сделать избранной? (1 - да, 0 - нет, пусто - не менять): ');
  String favInput = stdin.readLineSync() ?? '';
  bool? isFav = favInput == '1' ? true : (favInput == '0' ? false : null);

  if (repo.updateNote(id, title: title, isFavorite: isFav)) {
    print('Заметка обновлена!');
  } else {
    print('! Ошибка при обновлении.');
  }
}
