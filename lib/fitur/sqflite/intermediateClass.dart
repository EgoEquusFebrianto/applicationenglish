import 'package:applicationenglish/fitur/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class IntermediateHelper {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> insertIntermediateSentence(int id, String kalimat, String typeAns) async {
    final db = await _dbHelper.database;
    await db.insert(
      'intermediate',
      {
        'id': id,
        'kalimat': kalimat,
        'type_ans': typeAns,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertIntermediateWord(int id, int sentenceId, String word, bool cursor) async {
    final db = await _dbHelper.database;
    await db.insert(
      'intermediate_words',
      {
        'id': id,
        'sentence_id': sentenceId,
        'word': word,
        'cursor': cursor ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

    Future<List<Map<String, dynamic>>> fetchAllIntermediateSentences() async {
      final db = await _dbHelper.database;
      return await db.query('intermediate');
    }

  Future<List<Map<String, dynamic>>> fetchWordsByIntermediateSentenceId(int sentenceId) async {
    final db = await _dbHelper.database;
    return await db.query(
      'intermediate_words',
      where: 'sentence_id = ?',
      whereArgs: [sentenceId],
    );
  }

  Future<List<Map<String, dynamic>>> fetchIntermediateData() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> sentences = await db.query('intermediate');
    List<Map<String, dynamic>> result = [];
    
    for (var sentence in sentences) {
      // Ambil kata-kata berdasarkan sentence_id
      final List<Map<String, dynamic>> words = await db.query(
        'intermediate_words',
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
