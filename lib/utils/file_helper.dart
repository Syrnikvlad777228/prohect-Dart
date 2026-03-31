import 'dart:io';
import 'dart:convert';

class FileHelper {
  static const String _fileName = 'notes.json';

  static void saveNotes(List<Map<String, dynamic>> jsonData) {
    try {
      final file = File(_fileName);
      // !!!!ТУТ Я ПЫТАЛСЯ ПРЕОБРАЗОВАТЬ В UTF 8 НО ОНО НЕ РАБОТАЕТ ((
      final String content = jsonEncode(jsonData);
      file.writeAsStringSync(content, encoding: utf8); 
    } catch (e) {
      print('Ошибка сохранения: $e');
    }
  }

  static List<dynamic> loadNotes() {
    try {
      final file = File(_fileName);
      if (file.existsSync()) {
        final String content = file.readAsStringSync(encoding: utf8);
        return jsonDecode(content);
      }
    } catch (e) {
      print('Ошибка чтения: $e');
    }
    return [];
  }
}
