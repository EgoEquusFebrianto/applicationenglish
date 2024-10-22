import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WordProvider with ChangeNotifier {
  String? selector;
  List<dynamic> elementDict = [];
  String sortingType = 'id_asc';

  WordProvider() {
    loadingData();
  }

  Future<void> loadingData() async {
    String jsonFileUrl = 'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/dictionary.json';
    
    try {
      final response = await http.get(Uri.parse(jsonFileUrl));
      if (response.statusCode == 200) {
        elementDict = jsonDecode(response.body);
        _sortData();
      } else {
        throw Exception('Failed to load JSON data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error Loading Json: $e');
    }
    notifyListeners();
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
