import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

var predictNumber = "";
final predictNumberChanged = ChangeNotifier();
var predictResult = "";
final predictResultChanged = ChangeNotifier();

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
