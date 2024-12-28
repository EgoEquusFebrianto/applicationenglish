import 'package:applicationenglish/fitur/Challanges/myDictionary/_Provider.dart';
// import 'package:applicationenglish/fitur/sqflite/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestingForSqflite extends StatefulWidget {
  const TestingForSqflite({super.key});

  @override
  State<TestingForSqflite> createState() => _TestingForSqfliteState();
}

class _TestingForSqfliteState extends State<TestingForSqflite> {
  // final DatabaseHelper _dbHelper = DatabaseHelper();
  // bool? _result = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkDictionaryTable();
  // }

  // Future<void> _checkDictionaryTable() async {
  //   bool? result = await _dbHelper.isDictionaryTableEmpty();
  //   setState(() {
  //     _result = result;
  //   });
  // }
  
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<WordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Example for SQFLITE Dictionary"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text("${data.elementDict}"),
        ),
      ),
    );
  }
}