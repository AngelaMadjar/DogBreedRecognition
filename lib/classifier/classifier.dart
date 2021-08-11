import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Classifier{
  //initialization
  Classifier();

  //async because it might take some time for the model to run
  classifyImage(var image) async {
    var inputImage = File(image.path);

    ImageProcessor imageProcessor = ImageProcessorBuilder()
    .add(ResizeOp(224, 224, ResizeMethod.BILINEAR)) //resizing in case some image was not resizes (224 because of the efficient net b0)
    .add(NormalizeOp(0, 255)) //mean = 0, std = 225
    .build();
    
    TensorImage tensorImage = TensorImage.fromFile(inputImage);
    tensorImage = imageProcessor.process(tensorImage);

    //for the probabilities that we get as output
    TensorBuffer probabilityBuffer = 
        TensorBuffer.createFixedSize(<int>[1, 71], TfLiteType.float32);

    try{
      Interpreter interpreter = await Interpreter.fromAsset("b0_tflite");
      interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);
    } catch(e){
      print("Error loading or running model");
    }

    List<String> labels = await FileUtil.loadLabels("assets/labels.txt");
    SequentialProcessor<TensorBuffer> probabilityProcessor = TensorProcessorBuilder().build();
    TensorLabel tensorLabel = TensorLabel.fromList(
        labels, probabilityProcessor.process(probabilityBuffer));

    Map labeledProb = tensorLabel.getMapWithFloatValue();
    double highestProb = 0;
    late String dogBreed;

    labeledProb.forEach((breed, probability){
      if(probability*100 > highestProb){
        highestProb = probability*100;
        dogBreed = breed;
      }
    });
    var outputProb = highestProb.toStringAsFixed(1);
    return [dogBreed, outputProb];
  }
}