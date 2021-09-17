
import 'package:dog_breed_recognition/src/blocs/application_bloc.dart';
import 'package:dog_breed_recognition/src/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetMaps extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}