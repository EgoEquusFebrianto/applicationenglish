import 'package:flutter/material.dart';

void main() {
  runApp(MyHomeTesting());
}

class MyHomeTesting extends StatelessWidget {
  const MyHomeTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Testing Program",
      debugShowCheckedModeBanner: false,
      home: TestingBaby(),
    );
  }
}

class TestingBaby extends StatefulWidget {
  const TestingBaby({super.key});

  @override
  State<TestingBaby> createState() => _TestingBabyState();
}

class _TestingBabyState extends State<TestingBaby> {
  bool? result;
  int totalReward = 0;
  Map<String, dynamic> getReward = {
    "A1" : [1,2,3,4,5],
    "A2" : [1,2,3,4,5],
    "A3" : [1,2,3,4]
  };

  void setTotalReward() {
    getReward.forEach((key, value) {
      totalReward += value.length as int;
    });
  }

  @override
  void initState() {
    setTotalReward();
    print("value of the variable is $totalReward");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hell Yeah Coding"),
        backgroundColor: Colors.blue,
      ),
      body: Container(),
    );
  }
}