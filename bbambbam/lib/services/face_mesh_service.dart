import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../constants/model_file.dart';
import '../../utils/image_utils.dart';
import '../services/ai_model.dart';

// ignore: must_be_immutable
class FaceMesh extends AiModel {
  Interpreter? interpreter;

  FaceMesh({this.interpreter}) {
    loadModel();
  }

  final int inputSize = 192;

  @override
  List<Object> get props => [];

  @override
  int get getAddress => interpreter!.address;

  @override
  Interpreter? get getInterpreter => interpreter;

  @override
  Future<void> loadModel() async {
    print(
        "model load...-----------------------------------------------------------");
    try {
      final interpreterOptions = InterpreterOptions();

      interpreter ??= await Interpreter.fromAsset(ModelFile.faceMesh,
          options: interpreterOptions);

      final outputTensors = interpreter!.getOutputTensors();

      for (var tensor in outputTensors) {
        outputShapes.add(tensor.shape);
        outputTypes.add(tensor.type);
      }
    } catch (e) {
      log('Error while creating interpreter: $e');
    }
    print("Completed load models!");
  }

  @override
  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  Map<String, dynamic>? predict(image_lib.Image image) {
    print("predict funtcion~~~~~~");
    if (interpreter == null) {
      print("Interpreter is null");
      return null;
    }
    print("Original image dimensions: ${image.width}x${image.height}");
    if (Platform.isAndroid) {
      image = image_lib.copyRotate(image, -90);
      image = image_lib.flipHorizontal(image);
      print("image convert~~~~~~~~~");
      print("Image converted (rotated and flipped) for Android");
    }
    final tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(image);
    print("TensorImage loaded: ${tensorImage.buffer}");

    final inputImage = getProcessedImage(tensorImage);
    print("Processed TensorImage: ${inputImage.buffer}");

    print("outputShape: ${outputShapes}");

    TensorBuffer outputLandmarks = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[1]);

    final inputs = <Object>[inputImage.buffer];

    final outputs = <int, Object>{
      0: outputLandmarks.buffer,
      1: outputScores.buffer,
    };

    interpreter!.runForMultipleInputs(inputs, outputs);
    print("Inference run completed");

    double score = outputScores.getDoubleValue(0);
    print("Output score: ${score}");
    print("outputLandmark: ${outputLandmarks.getDoubleList().shape}");

    // if (outputScores.getDoubleValue(0) < 0) {
    //   print("outputScore is null");
    //   return null;
    // }

    final landmarkPoints = outputLandmarks.getDoubleList().reshape([468, 3]);
    print("Landmark points: $landmarkPoints");

    final landmarkResults = <Offset>[];
    for (var point in landmarkPoints) {
      landmarkResults.add(Offset(
        point[0] / inputSize * image.width,
        point[1] / inputSize * image.height,
      ));
    }
    print("Landmark results: $landmarkResults");
    return {'point': landmarkResults};
  }
}

Map<String, dynamic>? runFaceMesh(Map<String, dynamic> params) {
  print("i/m run face mesh!!------------------------------------");
  final faceMesh =
      FaceMesh(interpreter: Interpreter.fromAddress(params['detectorAddress']));
  final image = ImageUtils.convertCameraImage(params['cameraImage']);
  print("Converted image: ${image}");
  final result = faceMesh.predict(image!);
  print("run face mesh result : ${result}");
  return result;
}
