import 'package:applicationenglish/fitur/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BeginnerHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertBeginnerSentence(int id, String kalimat, String typeAns) async {
    final db = await _dbHelper.database;
    await db.insert(
      'beginner',
      {
        'id': id,
        'kalimat': kalimat,
        'type_ans': typeAns,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertBeginnerWord(int id, int sentenceId, String word) async {
    final db = await _dbHelper.database;
    await db.insert(
      'beginner_words',
      {
        'id': id,
        'sentence_id': sentenceId,
        'word': word,
        'cursor': false,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllBeginnerSentences() async {
    final db = await _dbHelper.database;
    return await db.query('beginner');
  }

  Future<List<Map<String, dynamic>>> fetchWordsByBeginnerSentenceId(int sentenceId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'beginner_words',
      where: 'sentence_id = ?',
      whereArgs: [sentenceId],
    );
  }

  Future<List<Map<String, dynamic>>> fetchBeginnerData() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> sentences = await db.query('beginner');
    List<Map<String, dynamic>> result = [];
    
    for (var sentence in sentences) {
      // Ambil kata-kata berdasarkan sentence_id
      final List<Map<String, dynamic>> words = await db.query(
        'beginner_words',
        where: 'sentence_id = ?',
        whereArgs: [sentence['id']],
      );

      result.add({
        "id": sentence['id'],
        "kalimat": sentence['kalimat'],
        "words": words.map((word) {
          return {
            "id": word['id'],
            "cursor": word['cursor'] == 1,
            "word": word['word'],
          };
        }).toList(),
        "typeAns": sentence['type_ans'],
      });
    }

    return result;
  }
}
