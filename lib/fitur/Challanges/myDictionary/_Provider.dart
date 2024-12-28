import 'package:applicationenglish/fitur/sqflite/database_helper.dart';
import 'package:applicationenglish/fitur/sqflite/dictionaryClass.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WordProvider with ChangeNotifier {
  String? selector;
  List<dynamic> elementDict = [];
  String sortingType = 'id_asc';

  final DatabaseHelper _dbHelper = DatabaseHelper();

  WordProvider() {
    loadingData();
  }

Future<void> _saveToDatabase() async {
  for (var entry in elementDict) {
    try {
      await _dbHelper.insertDictionaryEntry(
        UserDictionary(
          id: entry['id'], 
          word: entry['word'], 
          translate: List<String>.from(entry['translate']), 
          tabs_bar: entry['TabsBar'] ?? 'Sedang Dipelajari'
        )
      );
    } catch (e) {
      print('Error saving entry to database: $e');
    }
  }
}

  Future<void> loadingData() async {
    await _dbHelper.isDictionaryTableEmpty().then((isEmpty) async {
    try {
      if (isEmpty!) {
        const jsonFileUrl = 'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/dictionary.json';
        final response = await http.get(Uri.parse(jsonFileUrl));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data is List) {
            elementDict = data;
            _sortData();
            await _saveToDatabase();
          } else {
            throw Exception('Invalid JSON format: Expected a list of entries');
          }
        } else {
          throw Exception('Failed to load JSON data: ${response.statusCode}');
        }
      } else {
        elementDict = await _dbHelper.fetchDictionaryData();
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      notifyListeners();
    }
    });
  }

  List<Map<String, dynamic>> get words => List<Map<String, dynamic>>.from(elementDict);

  List<Map<String, dynamic>> getWordsByTab(String tab) {
    return words.where((word) => word['TabsBar'] == tab).toList();
  }

  void toggleExpanded(String id) {
    if (selector == id) {
      selector = null;
    } else {
      selector = id;
    }
    notifyListeners();
  }

  void setSortingType(String type) {
    sortingType = type;
    _sortData();
    notifyListeners();
  }

  void _sortData() {
    switch (sortingType) {
      case 'id_asc':
        elementDict.sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));
        break;
      case 'word_asc':
        elementDict.sort((a, b) => a['word'].compareTo(b['word']));
        break;
      case 'word_desc':
        elementDict.sort((a, b) => b['word'].compareTo(a['word']));
        break;
    }
  }
}
