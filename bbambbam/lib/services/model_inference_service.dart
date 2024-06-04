import 'dart:isolate';

import 'package:camera/camera.dart';

import '../utils/isolate_utils.dart';
import 'ai_model.dart';

import './face_mesh_service.dart';
import 'service_locator.dart';

enum Models {
  faceDetection,
  faceMesh,
  hands,
  pose,
}

class ModelInferenceService {
  late AiModel model;
  late Function handler;
  Map<String, dynamic>? inferenceResults;

  Future<void> inference({
    required IsolateUtils isolateUtils,
    required CameraImage cameraImage,
  }) async {
    final responsePort = ReceivePort();
    print(
        "Sending message with params: {'cameraImage': ${cameraImage}, 'detectorAddress': ${model.getAddress}}");

    isolateUtils.sendMessage(
      handler: handler,
      params: {
        'cameraImage': cameraImage,
        'detectorAddress': model.getAddress,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    inferenceResults = await responsePort.first;
    print("inference Result is: ${inferenceResults}");
    responsePort.close();
  }

  // TODO : Models enum 제거하기
  void setModelConfig() {
    model = locator<FaceMesh>();
    handler = runFaceMesh;
  }
}
