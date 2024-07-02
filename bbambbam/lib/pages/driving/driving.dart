import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// google ml kit
import 'dart:io';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'detector_view.dart';
import 'painters/face_mesh_detector_painter.dart';
import 'dart:math';


class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  final FaceMeshDetector _meshDetector = 
    FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _meshDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return DetectorView(
      title: 'Face Mesh Detection',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

// 두 점 사이의 거리 계산
  num euclideanDistance(num x1, num y1, num x2, num y2){
    var point1 = Point(x1, y1);
    var point2 = Point(x2, y2);
    return point1.distanceTo(point2);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState((){
      _text = '';
    });
    final meshes = await _meshDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null){
      final painter = FaceMeshDetectorPainter(
        meshes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);

      var leftEAR;
      var rightEAR;

      
      // 눈 좌표
      for (final mesh in meshes){
        List<FaceMeshPoint>? leftEyePoints = mesh.contours[FaceMeshContourType.leftEye];
        List<FaceMeshPoint>? rightEyePoints = mesh.contours[FaceMeshContourType.rightEye];

        if (leftEyePoints != null){
          //print("Left Eye Points:");
          // for (var point in leftEyePoints){
          //   print("Index: ${point.index}, X: ${point.x}, Y: ${point.y}");
          // }
          // print("Index: ${leftEyePoints[3].index}, X: ${leftEyePoints[3].x}, Y: ${leftEyePoints[3].y}");
          // print("Index: ${leftEyePoints[13].index}, X: ${leftEyePoints[13].x}, Y: ${leftEyePoints[13].y}");
          // print("Index: ${leftEyePoints[5].index}, X: ${leftEyePoints[5].x}, Y: ${leftEyePoints[5].y}");
          // print("Index: ${leftEyePoints[11].index}, X: ${leftEyePoints[11].x}, Y: ${leftEyePoints[11].y}");
          // print("Index: ${leftEyePoints[0].index}, X: ${leftEyePoints[0].x}, Y: ${leftEyePoints[0].y}");
          // print("Index: ${leftEyePoints[8].index}, X: ${leftEyePoints[8].x}, Y: ${leftEyePoints[8].y}");

        // 계산식 약간 다름(ear 식 참고)
          var leftEar1 = euclideanDistance(leftEyePoints[3].x, leftEyePoints[3].y, leftEyePoints[13].x, leftEyePoints[13].y);
          var leftEar2 = euclideanDistance(leftEyePoints[5].x, leftEyePoints[5].y, leftEyePoints[11].x, leftEyePoints[11].y);
          var leftEar3 = euclideanDistance(leftEyePoints[0].x, leftEyePoints[0].y, leftEyePoints[8].x, leftEyePoints[8].y);

          leftEAR = (leftEar1 + leftEar2) / (2.0 * leftEar3);
        }

        if (rightEyePoints != null){
          //print("Right Eye Points:");
          // print("Index: ${rightEyePoints[3].index}, X: ${rightEyePoints[3].x}, Y: ${rightEyePoints[3].y}");
          // print("Index: ${rightEyePoints[13].index}, X: ${rightEyePoints[13].x}, Y: ${rightEyePoints[13].y}");
          // print("Index: ${rightEyePoints[5].index}, X: ${rightEyePoints[5].x}, Y: ${rightEyePoints[5].y}");
          // print("Index: ${rightEyePoints[11].index}, X: ${rightEyePoints[11].x}, Y: ${rightEyePoints[11].y}");
          // print("Index: ${rightEyePoints[0].index}, X: ${rightEyePoints[0].x}, Y: ${rightEyePoints[0].y}");
          // print("Index: ${rightEyePoints[8].index}, X: ${rightEyePoints[8].x}, Y: ${rightEyePoints[8].y}");

          var rightEar1 = euclideanDistance(rightEyePoints[3].x, rightEyePoints[3].y, rightEyePoints[13].x, rightEyePoints[13].y);
          var rightEar2 = euclideanDistance(rightEyePoints[5].x, rightEyePoints[5].y, rightEyePoints[11].x, rightEyePoints[11].y);
          var rightEar3 = euclideanDistance(rightEyePoints[0].x, rightEyePoints[0].y, rightEyePoints[8].x, rightEyePoints[8].y);

          rightEAR = (rightEar1 + rightEar2) / (2.0 * rightEar3);
        }

      
        // 눈 감김 여부 판단
        if (leftEAR != null && rightEAR != null){
          var ear = (leftEAR + rightEAR) / 2.0;
          if (ear < 0.2){
            print("Eyes are closed");
          }
        }
      }
    } else {
      String text = 'Face meshes found: ${meshes.length}\n\n';
      for (final mesh in meshes){
        text += 'face: ${mesh.boundingBox}\n\n';
      }
       _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted){
      setState(() {});
    }
  }
}

// class _DrivingState extends State<Driving> with WidgetsBindingObserver{
  // CameraController? _cameraController;
  // late List<CameraDescription> _cameras;
  // late CameraDescription _cameraDescription;

  // late bool _isRun;
  // bool _predicting = false;
  // bool _draw = false;

  // late IsolateUtils _isolateUtils;
  // late ModelInferenceService _modelInferenceService;

  // late User _user;

  // @override
  // void initState() {
  //   super.initState();
  //   _modelInferenceService = locator<ModelInferenceService>();
  //   _initStateAsync();
  //   _getUser();
  // }

  // void _initStateAsync() async {
  //   _isolateUtils = IsolateUtils();
  //   await _isolateUtils.initIsolate();
  //   await _initCamera();
  //   _predicting = false;
  // }

  // @override
  // void dispose() {
  //   _cameraController?.dispose();
  //   _cameraController = null;
  //   _isolateUtils.dispose();
  //   _modelInferenceService.inferenceResults = null;
  //   super.dispose();
  // }

  // Future<void> _initCamera() async {
  //   _cameras = await availableCameras();
  //   _cameraDescription = _cameras[1];
  //   _isRun = false;
  //   _onNewCameraSelected(_cameraDescription);
  // }

  // void _onNewCameraSelected(CameraDescription cameraDescription) async {
  //   _cameraController = CameraController(
  //     cameraDescription,
  //     ResolutionPreset.medium,
  //     enableAudio: false,
  //   );

  //   _cameraController!.addListener(() {
  //     if (mounted) setState(() {});
  //     if (_cameraController!.value.hasError){
  //       _showInSnackBar(
  //         'Camera error ${_cameraController!.value.errorDescription}'
  //       );
  //     }
  //   });

  //   try {
  //     await _cameraController!.initialize().then((value){
  //       if (!mounted) return;
  //     });
  //   } on CameraException catch (e){
  //     _showInSnackBar('Error: ${e.code}\n${e.description}');
  //   }

  //   if (mounted){
  //     setState(() {});
  //   }
  // }

  // void _showInSnackBar(String message){
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }


  // Future<void> _getUser() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     setState(() {
  //       _user = user;
  //     });
  //   }
  // }

  // Future<void> _addReport() async {
  //   CollectionReference reports = FirebaseFirestore.instance
  //       .collection('User')
  //       .doc(_user.uid)
  //       .collection('Reports');
  //   await reports.add({
  //     'warning': true,
  //     'date': '2022-01-02',
  //     'start_driving_time': '00:00:00',
  //     'end_driving_time': '00:00:00',
  //     'time_stamp': '00:00:00, 00:00:00, 00:00:00',
  //   });
  // }



  // @override
  // Widget build(BuildContext context) {
  //   return PopScope(
  //     canPop: true,
  //     onPopInvoked: (didPop){
  //       if (_isRun){
  //         _imageStreamToggle;
  //       }
  //     },
  //     child: Scaffold(
  //       backgroundColor: Colors.black,
  //       body: ModelCameraPreview(
  //         cameraController: _cameraController,
  //         draw: _draw,
  //         ),
  //         floatingActionButton: _buildFloatingActionButton,
  //         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  //       ),
  //   );
    // return Scaffold(
    //   body: FutureBuilder<void>(
    //     future: _initializeControllerFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return Stack(
    //           children: <Widget>[
    //             CameraPreview(_controller),
    //             Positioned(
    //               left: 0,
    //               bottom: 0,
    //               child: FloatingActionButton(
    //                   child: Icon(Icons.stop),
    //                   onPressed: () => handleStopClick(context)
    //                       ),
    //             ),
    //             Positioned(
    //               right: 0,
    //               bottom: 0,
    //               child: FloatingActionButton(
    //                 child: Icon(Icons.pause),
    //                 onPressed: () {
    //                   _controller.pauseVideoRecording();
    //                 },
    //               ),
    //             ),
    //           ],
    //         );
    //       } else {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //     },
    //   ),
    // );
  // }

  // Row get _buildFloatingActionButton => Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   children: [
  //     IconButton(
  //       onPressed: () => handleStopClick(context),
  //       color: Colors.white,
  //       iconSize: ScreenUtil().setWidth(30.0),
  //       icon: const Icon(
  //         Icons.stop,
  //       ),
  //     ),
  //     // 일단 model test를 위해 모델 실행 버튼으로 대체
  //     IconButton(
  //       onPressed: () => _imageStreamToggle,
  //       color: Colors.white,
  //       iconSize: ScreenUtil().setWidth(30.0),
  //       icon: const Icon(
  //         Icons.filter_center_focus,
  //         ),
  //       ),
  //   ],
  //   );
  
  //   void handleStopClick(BuildContext context) {
  //   try {
  //     print('Stop Clicked');
  //     _addReport();
  //     Navigator.of(context).pop();
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }


  // void get _imageStreamToggle {
  //   setState((){
  //     _draw = !_draw;
  //   });

  //   _isRun = !_isRun;
  //   if (!_isRun) {
  //     print("_____stop image stream_____");
  //   }
  //   if (_isRun) {
  //     print("_____start image stream_____");
  //     _cameraController!.startImageStream(
  //       (CameraImage cameraImage) async =>
  //         await _inference(cameraImage: cameraImage),
  //     );
  //   } else {
  //     _cameraController!.stopImageStream();
  //   }
  // }

  // Future<void> _inference({required CameraImage cameraImage}) async {
  //   if (!mounted) return;

  //   if (_modelInferenceService.model.getInterpreter != null){
  //     if (_predicting || !_draw) {
  //       return;
  //     }

  //     setState(() {
  //       _predicting = true;
  //     });

  //     if (_draw){
  //       //print("_____start inference_____");
  //       await _modelInferenceService.inference(
  //         isolateUtils: _isolateUtils,
  //         cameraImage: cameraImage,
  //       );
  //     }

  //     setState((){
  //       _predicting = false;
  //     });
  //     print("_____end inference_____");

  //     }
  //   }
  // }

