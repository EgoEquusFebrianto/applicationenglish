// dictionary.dart
import 'package:applicationenglish/fitur/profile/provider/switchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '_Provider.dart';

class WordListScreen extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    var theme = Provider.of<SwitchModeProvider>(context).themeData;
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Word List', 
            style: theme.appBarTheme.titleTextStyle,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          iconTheme: theme.appBarTheme.iconTheme,
          bottom: PreferredSize(preferredSize: Size.fromHeight(144.0), // Height for AppBar + TabBar + Button + Dropdown
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.lightBlue,
                  unselectedLabelColor: Colors.red,
                  tabs: [
                    Tab(text: 'Under Study'),
                    Tab(text: 'Has Been Learned'),
                  ],
                ),
                SizedBox(height: 8), // Space between TabBar and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SortOptionsSheet();
                          },
                        );
                      },
                      child: Text("Sort Options"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Use FutureBuilder to load words asynchronously
        backgroundColor: theme.scaffoldBackgroundColor,
        body: FutureBuilder(
          future: Provider.of<WordProvider>(context, listen: false).dataInitialize(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return TabBarView(
                children: [
                  WordList(tab: 'Sedang Dipelajari'),
                  WordList(tab: 'Telah Dipelajari'),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class WordList extends StatelessWidget {
  final String tab;

  WordList({required this.tab});

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<WordProvider>(context).getWordsByTab(tab);

    return ListView(
      children: [
        ...words.map((word) {
          return WordTile(word: word);
        }).toList(),
        CatalogSummary(wordCount: words.length),
      ],
    );
  }
}

class WordTile extends StatelessWidget {
  final Map<String, dynamic> word;

  WordTile({required this.word});

  @override
  Widget build(BuildContext context) {
    final isExpanded = Provider.of<WordProvider>(context).selector == word['id'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              word['word'],
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Provider.of<WordProvider>(context, listen: false).toggleExpanded(word['id']);
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (word['translate'] as List<dynamic>).map((translation) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      translation,
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.left,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class SortOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentSorting = Provider.of<WordProvider>(context).sortingType;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort Options',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          _buildRadioListTile(
            context: context,
            title: 'Sort by Time Acquired',
            value: 'id_asc',
            groupValue: currentSorting,
          ),
          _buildRadioListTile(
            context: context,
            title: 'Sort by Word A-Z',
            value: 'word_asc',
            groupValue: currentSorting,
          ),
          _buildRadioListTile(
            context: context,
            title: 'Sort by Word Z-A',
            value: 'word_desc',
            groupValue: currentSorting,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile({
    required BuildContext context,
    required String title,
    required String value,
    required String groupValue,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (String? newValue) {
          if (newValue != null) {
            Provider.of<WordProvider>(context, listen: false).setSortingType(newValue);
            Navigator.pop(context);
          }
        },
      ),
      onTap: () {
        Provider.of<WordProvider>(context, listen: false).setSortingType(value);
        Navigator.pop(context);
      },
    );
  }
}

class CatalogSummary extends StatelessWidget {
  final int wordCount;

  CatalogSummary({required this.wordCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(Icons.menu_book_sharp, size: 50, color: Colors.black87),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Word Count', style: TextStyle(fontSize: 16)),
              Text(wordCount.toString(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
