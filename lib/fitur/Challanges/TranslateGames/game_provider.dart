import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'EndGamePage.dart';

class GameProvider extends ChangeNotifier {
  bool clear = false;
  int start = 0;
  List<Map<String, dynamic>> dataGame = [];
  List<Map<String, dynamic>> sampleData1 = [];
  List<Map<String, dynamic>> sampleData2 = [];
  String onClick1 = '';
  String onClick2 = '';
  double progress = 0;
  int onStage = 5;
  int sessionCount = 0;
  int totalRounds = 5;
  Map<String, bool> activate1 = {};
  Map<String, bool> activate2 = {};
  bool wrongAnswer = false;
  bool lockInteraction = false;
  bool nextSession = false;

  GameProvider() {
    loadWords();
  }

  Future<void> loadWords() async {
    if (dataGame.isEmpty) {
      final String jsonFileUrl =
          'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/dictionary.json';
      try {
        final response = await http.get(Uri.parse(jsonFileUrl));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          dataGame = data.map((item) {
            return {
              'id': item['id'],
              'word': item['word'],
              'translate': List<String>.from(item['translate']),
              'cursor': 1
            };
          }).toList();

          dataGame.shuffle();
          notifyListeners();
          getSampleData();
          initializeActivateMaps();
        } else {
          throw Exception('Failed to load JSON data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error loading words: $e');
      }
    }
  }

  void getSampleData() {
    sampleData1.clear();
    sampleData2.clear();

    if (start >= dataGame.length) {
      clear = true;
      notifyListeners();
      return;
    }

    int availableDataCount = dataGame.length - start;
    int takeCount = availableDataCount < 5 ? availableDataCount : 5;
    sampleData1 = dataGame.skip(start).take(takeCount).toList();
    sampleData2 = dataGame.skip(start).take(takeCount).toList();
    sampleData1.shuffle();
    sampleData2.shuffle();
    start += takeCount;
    initializeActivateMaps();
    notifyListeners();
  }

  void initializeActivateMaps() {
    activate1 = {for (var item in sampleData1) item['id']: true};
    activate2 = {for (var item in sampleData1) item['id']: true};
    notifyListeners();
  }

  void setOnClick(int type, String id) {
    if (lockInteraction) return;

    if (type == 1) {
      onClick1 = onClick1 == id ? '' : id;
    } else if (type == 2) {
      onClick2 = onClick2 == id ? '' : id;
    }
    notifyListeners();
  }

  void checkMatching() async {
    if (onClick1 == onClick2 && onClick1 != '') {
      activate1[onClick1] = false;
      activate2[onClick2] = false;
      progress += 1;
      onStage -= 1;
      onClick1 = '';
      onClick2 = '';

      if (onStage == 0) {
        nextSessionCheck();
      }
    } else if (onClick1 != '' && onClick2 != '') {
      wrongAnswer = true;
      lockInteraction = true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 1));

      wrongAnswer = false;
      lockInteraction = false;
      onClick1 = '';
      onClick2 = '';
    }

    notifyListeners();
  }

  void nextSessionCheck() {
    sessionCount += 1;

    if (sessionCount < totalRounds) {
      refreshOnStage();
    } else {
      nextSession = true;
      notifyListeners();
    }
  }

  void refreshOnStage() {
    getSampleData();
    onStage = sampleData1.length;
    notifyListeners();
  }

  void startNewRound() {
    sessionCount = 0;
    progress = 0;
    nextSession = false;
    getSampleData();
    notifyListeners();
  }

  Future<void> handleCompletion(BuildContext context) async {
    if (clear) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EndGamePage()),
      );
    }
  }
}
