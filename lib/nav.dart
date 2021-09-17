
/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'package:dog_breed_recognition/pet_maps.dart';
import 'package:dog_breed_recognition/src/screens/map_screen.dart';
import 'package:dog_breed_recognition/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:dog_breed_recognition/dog_scanner.dart';
import 'dog_searcher.dart';



// NOTE: This class creates the navigation bar

class Nav extends StatefulWidget {
  final Future<void> Function() logoutAction;
  Nav(this.logoutAction, {Key? key});

  @override
 _NavState createState() => _NavState(logoutAction);

}

class _NavState extends State<Nav> {
  int _selectedIndex = 0; // the selected index of the navigation bar
  // the selected index should be displayed on tap
  late final Future<void> Function() logoutAction;

  _NavState(this.logoutAction, {Key? key});

  List<Widget> _widgetOptions = <Widget>[
    Home(), // index 0 (corresponding to the scanner feature)
    PetMaps(), // index 1
    SearchScreen(), // index 2 (corresponding to the searching dogs for sale feature)
    Text('log out'), // index 3 (log out)
  ];


  // adding functionality to the navbar
  Future<void> _onItemTap(int index) async {
    if(index==3){
      await logoutAction();
    }
    else{
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            title: Text('Pet Needs'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_rounded),
            title: Text('Log out'),

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTap,
     ),
    );
  }
}

