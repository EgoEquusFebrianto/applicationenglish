class UserDictionary {
  final String id;
  final String word;
  final List<String> translate;
  final String tabs_bar;

  UserDictionary({
    required this.id,
    required this.word,
    required this.translate,
    required this.tabs_bar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'translate': translate.join(','),
      'tabs_bar': tabs_bar,
    };
  }

  // Konversi dari Map
  factory UserDictionary.fromMap(Map<String, dynamic> map) {
    return UserDictionary(
      id: map['id'],
      word: map['word'],
      translate: map['translate'] != null
          ? (map['translate'] as String).split(',') : [],
      tabs_bar: map['tabs_bar'] ?? "Sedang Dipelajari",
    );
  }

  @override
  String toString() {
    return 'UserDictionary(id: $id, word: $word, translate: $translate, tabs_bar: $tabs_bar)';
  }
}
