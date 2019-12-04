import 'package:flutter/foundation.dart';

class Task {
  final String title;
  final String description;
  final String category;
  final int et;
  final int price;
  final String location;
  final DateTime date;

  Task({
      @required this.title,
      @required this.description,
      @required this.category,
      @required this.et,
      @required this.price,
      @required this.location,
      @required this.date});
}
