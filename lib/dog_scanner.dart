import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dog_breed_recognition/classifier/classifier.dart';
import 'classifier/classifier.dart';


// NOTE: This class provides the main functionality of the app - classifying the dog breed



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // An instance of the trained model
  final Classifier classifier = Classifier();

  // Enables choosing an image
  final picker = ImagePicker();

  // At the beginning the dog breed is an empty string
  String dogBreed = "";

  // A variable that will store the accuracy of the prediction (probability)
  late String dogProb;

  // The chosen image
  var image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // First, we create the background
      body: Stack(
        // We use stack since we will put two layers on top of each other
        children: [
          // The layer in the back
          Positioned(
              height: size.height * 0.4, // Cover 40% of the top of the screen
              width: size.width, // Cover full width
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                image: dogBreed == ""
                    ? AssetImage("assets/cavaliers_background.jpg")
                        as ImageProvider
                    : FileImage(File(image.path)),
                fit: BoxFit.cover,
              )))),
          // The layer in the front
          Positioned(
            top: size.height * 0.35, // We want some overlap with the back layer
            height: size.height * 0.65, // Sum up to 1
            width: size.width, // Cover full width
            child: Container(
              // Creating rounded angles on the front layer
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              // Adding text to the front layer
              child: Column(
                children: [
                  SizedBox(
                    height: 80, // Push the text down
                  ),
                  Text(
                    "Dog Breed Prediction",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(dogBreed == "" ? "" : "$dogProb% $dogBreed", // If the classifier worked successfully,
                      // There will be some values for the dogBreed and the accuracy of the prediction
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 90,
                  ),
                  // Creating buttons
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

                              // One option is to classify an image taken at the moment
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

                              // Another option is to classify an image chosen from gallery
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
