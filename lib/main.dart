import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dog_breed_recognition/nav.dart';

// Ctrl + Alt + L to auto format the code

void main() {
  runApp(MaterialApp(
      home: Nav(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      )));
}