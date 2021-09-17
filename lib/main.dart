// @dart=2.9
import 'package:dog_breed_recognition/auth.dart';
import 'package:dog_breed_recognition/src/blocs/application_bloc.dart';
import 'package:dog_breed_recognition/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dog_breed_recognition/nav.dart';

// Ctrl + Alt + L to auto format the code

void main() {
  runApp(MaterialApp(
      home: MyApp(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      )));
}
