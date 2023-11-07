import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [
    Data(name: 'Shopping', percent: 40, color: Colors.blue),
    Data(name: 'Transportation', percent: 30, color: Colors.orange),
    Data(name: 'Food&Beverage', percent: 10, color: Colors.yellow),
    Data(name: 'Electronics', percent: 10, color: Colors.black),
    Data(name: 'OtherExpenses', percent: 10, color: Colors.green),
  ];
}

class Data {
  final String name;
  final double percent;
  final Color color;
  Data({required this.name, required this.percent, required this.color});
}
