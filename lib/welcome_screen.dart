import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const WelcomeScreen(this.loginAction, this.loginError, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pexels-anna-perkas-2039823.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
              ),

              Container(
                  height: 450,
                  width: 450,
                  child: Image(image: AssetImage('assets/dbr_white.png'))),
              // SizedBox(
              //   height: 50,
              // ),
              Text(loginError ?? ''),


            ],

          ),
        ),
      ),
        floatingActionButton: Padding(
           padding: const EdgeInsets.only(bottom: 200.0),
           child: FloatingActionButton.extended(
             onPressed: () async {
               await loginAction();
             },
             label: const Text('Continue to login'),
             icon: const Icon(Icons.arrow_right),
             backgroundColor: Colors.blue[800],
           )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}