import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

// getPredict
var predictNumber = "";
final predictNumberChanged = ChangeNotifier();
var predictResult = "";
final predictResultChanged = ChangeNotifier();

// getGuideline
var guidelines = [];
final guidelinesChanged = ChangeNotifier();

// getTesting
var testings = [];
final testingsChanged = ChangeNotifier();

// เซียมซี
void getPredict() async {
  Random random = Random();
  int randomNumber = random.nextInt(28) + 1;

  final result = await http.get(
    Uri.parse(
        'https://xn--42cm7czac0a7jb0li.com/getPredict.php?data=$randomNumber'),
  );

  final json = jsonDecode(result.body);
  predictNumber = json['id'];
  predictResult = json['result'];
  predictNumberChanged.notifyListeners();
  predictResultChanged.notifyListeners();
}

// แนวข้อสอบ
void getGuideline() async {
  final result = await http.get(
    Uri.parse('https://xn--42cm7czac0a7jb0li.com/getGuideline.php'),
  );

  final json = jsonDecode(result.body);
  guidelines.clear();
  guidelines.addAll(json);
  guidelinesChanged.notifyListeners();
}

// ข้อสอบ
void getTesting() async {
  final result = await http.get(
    Uri.parse('https://xn--42cm7czac0a7jb0li.com/getExamApp.php'),
  );

  final json = jsonDecode(result.body);
  testings.clear();
  // testings.addAll(json);
  for (int i = 0; i < json.length; i++) {
    testings.add(
      {
        'topic': i,
        'question': json[i]['question'],
        'ch1': json[i]['ch1'],
        'ch2': json[i]['ch2'],
        'ch3': json[i]['ch3'],
        'ch4': json[i]['ch4'],
        'ref': json[i]['ref'],
        'answer': json[i]['answer'],
        'answer_user': '0',
      },
    );
  }
  testingsChanged.notifyListeners();
}
