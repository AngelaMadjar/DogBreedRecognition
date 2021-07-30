import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dog_breed_recognition/classifier.dart';
import 'classifier.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Classifier classifier = Classifier();
  final picker = ImagePicker();
  String dogBreed = "";
  late String dogProb;
  var image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      //First, we create the background
      body: Stack(
        //we use stack since we will put two layers on top of each other
        children: [
          //the layer in the back
          Positioned(
              height: size.height * 0.4, //cover 40% of the top of the screen
              width: size.width, //cover full width
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: dogBreed == ""
                    ? AssetImage("assets/cavaliers_background.jpg")
                        as ImageProvider
                    : FileImage(File(image.path)),
                fit: BoxFit.cover,
              )))),
          //The layer in the front
          Positioned(
            top: size.height * 0.35, //we want some overlap with the back layer
            height: size.height * 0.65, //sum up to 1
            width: size.width, //cover full width
            child: Container(
              //creating rounded angles on the front layer
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              //Adding text to the front layer
              child: Column(
                children: [
                  SizedBox(
                    height: 80, //push the text down
                  ),
                  Text(
                    "Prediction",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(dogBreed == "" ? "" : "$dogProb% $dogBreed",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 90,
                  ),
                  //Creating buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          OutlineButton(
                            onPressed: () async {
                              image = await picker.getImage(
                                  source: ImageSource.camera,
                                  maxHeight: 300,
                                  maxWidth: 300,
                                  imageQuality: 100);

                              final outputs =
                                  await classifier.classifyImage(image);

                              setState(() {
                                dogBreed = outputs[0];
                                dogProb = outputs[1];
                              });
                            },
                            highlightedBorderColor: Colors.orange,
                            highlightElevation: 10.0,
                            color: Colors.white,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            shape: CircleBorder(),
                            child: Icon(Icons.camera_alt,
                                size: 35, color: Colors.orange),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Take Photo",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Column(
                        children: [
                          OutlineButton(
                            onPressed: () async {
                              image = await picker.getImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 300,
                                  maxWidth: 300,
                                  imageQuality: 100);

                              final outputs =
                                  await classifier.classifyImage(image);

                              setState(() {
                                dogBreed = outputs[0];
                                dogProb = outputs[1];
                              });
                            },
                            highlightedBorderColor: Colors.blue[800],
                            highlightElevation: 10.0,
                            color: Colors.white,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(16.0),
                            shape: CircleBorder(),
                            child: Icon(Icons.photo,
                                size: 35, color: Colors.blue[800]),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "From gallery",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
