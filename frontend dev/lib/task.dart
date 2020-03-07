import 'package:flutter/foundation.dart';
import 'dart:io';
class Task {
  final String title;
  final String description;
  final String category;
  final int et;
  final int price;
  final int id;
  final String location;
  final DateTime date;
  final File picture;

  Task({
      @required this.title,
      @required this.description,
      @required this.category,
      @required this.et,
      @required this.price,
      @required this.location,
      @required this.date,
      @required this.id,
      this.picture});
}
