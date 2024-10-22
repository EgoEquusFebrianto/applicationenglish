import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClickedButtonListProvider with ChangeNotifier {
  int play = 0;
  int indexing = 0;
  List<Map> firstContainer = [];
  List<dynamic> elementList = [];
  List element = [];
  List answer = [];
  int level = 1;
  Map groupAnswerCursor = {
    "A": [1, 2],
    "B": [1, 2, 3],
    "C": [1, 2, 3, 4],
    "D": [1, 2, 3, 4, 5],
    "E": [1, 2, 3, 4, 5, 6],
    "F": [1, 2, 3, 4, 5, 6, 7],
    "G": [1, 2, 3, 4, 5, 6, 7, 8],
    "H": [1, 2, 3, 4, 5, 6, 7, 8, 9],
    "I": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    "J": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    "K": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  };

  bool showAnimation = false;
  bool showCorrectAnimation = false;
  bool showIncorrectAnimation = false;
  bool showAllElementsExplored = false;

  ClickedButtonListProvider() {
    loadData();
  }

  void setLevel(int num) {
    if (level != num && num == 1) {
      level = 1;
    } else if (level != num && num == 2) {
      level = 2;
    } else if (level != num && num == 3) {
      level = 3;
    } else {
      print('This Same');
      return;
    }
    cleaning();
    notifyListeners();
    loadData();
  }

  void cleaning() {
    elementList.clear();
    element.clear();
    firstContainer.clear();
    answer.clear();
    notifyListeners();
  }

  Future<void> loadData() async {
    String jsonFileUrl;
    switch (level) {
      case 2:
        jsonFileUrl = 'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/intermediate.json';
        break;
      case 3:
        jsonFileUrl = 'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/advance.json';
        break;
      default:
        jsonFileUrl = 'https://raw.githubusercontent.com/EgoEquusFebrianto/public_data/main/beginner.json';
    }

    try {
      final response = await http.get(Uri.parse(jsonFileUrl));
      if (response.statusCode == 200) {
        elementList = jsonDecode(response.body);
        element = elementList[indexing]['words'];
        element.shuffle();
      } else {
        throw Exception('Failed to load JSON data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading JSON: $e');
    }
    notifyListeners();
  }

  void setPlay(int func) {
    if (func == 0) {
      play += 1;
    } else {
      play = 0;
    }
    notifyListeners();
    loadData();
  }

  void updateFirstContainer(bool access, Map item) {
    if (!access) {
      firstContainer.add(item);
    } else {
      firstContainer.removeWhere((element) => element['id'] == item['id']);
    }
    notifyListeners();
  }

  void updateElement(bool access, int _id) {
    for (var e in element) {
      if (e['id'] == _id) {
        e['cursor'] = !access;
        notifyListeners();
        break;
      }
    }
  }

  bool listsEqual(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }

    return list1.asMap().entries.every((entry) => entry.value == list2[entry.key]);
  }

  void updateIndexElement() {
    if (indexing < elementList.length &&
        listsEqual(answer, groupAnswerCursor[elementList[indexing]['typeAns']])) {
      showCorrectAnimation = true;
      showIncorrectAnimation = false;
      showAnimation = true;
      notifyListeners();
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        if (indexing < elementList.length - 1) {
          element.forEach((e) => e['cursor'] = false);
        }
        showAnimation = false;
        showCorrectAnimation = false;
        indexing += 1;
        if (indexing < elementList.length) {
          firstContainer = [];
          answer = [];
          element = elementList[indexing]['words'];
          element.shuffle();
        } else {
          showAllElementsExplored = true;
        }
        notifyListeners();
      });
    } else if (indexing < elementList.length &&
        !listsEqual(answer, groupAnswerCursor[elementList[indexing]['typeAns']])) {
      showCorrectAnimation = false;
      showIncorrectAnimation = true;
      showAnimation = true;
      notifyListeners();
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        showAnimation = false;
        showIncorrectAnimation = false;
        notifyListeners();
      });
    } else {
      print('Element Already Reach maximum capacity');
    }
  }

  void updateListAnswer(int id, int index) {
    if (id == 0) {
      answer.removeWhere((element) => element == index);
    } else {
      answer.add(index);
    }
    notifyListeners();
  }

  void notify() {
    element.forEach((e) => e['cursor'] = false);
    indexing = 0;
    firstContainer = [];
    answer = [];
    showAnimation = false;
    showCorrectAnimation = false;
    showIncorrectAnimation = false;
    showAllElementsExplored = false;
    element = elementList[indexing]['words'];
    element.shuffle();
    notifyListeners();
  }
}
