import 'package:flutter/material.dart';
import 'package:dog_breed_recognition/dog_scanner.dart';
import 'dog_searcher.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0; // the selected index of the navigation bar
  // the selected index should be displayed on tap

  List<Widget> _widgetOptions = <Widget>[
    Home(), // index 0 (corresponding page for the selected icon)
    Text('Second Page'), // index 1
    SearchScreen(), // index 2
  ];

  // adding functionality to the navbar
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded),
            title: Text('Scanner'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            title: Text('Dogs'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            title: Text('Search'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTap,
      ),
    );
  }
}
