import 'package:bbambbam/pages/driving/widget/model_camera_preview.dart';
import 'package:bbambbam/services/model_inference_service.dart';
import 'package:bbambbam/services/service_locator.dart';
import 'package:bbambbam/utils/isolate_utils.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbambbam/pages/home/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> with WidgetsBindingObserver {
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;
  late User _user;
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  late CameraDescription _cameraDescription;

  late bool _isRun;
  bool _predicting = false;
  bool _draw = false;

  late IsolateUtils _isolateUtils;
  late ModelInferenceService _modelInferenceService;

  @override
  void initState() {
    _modelInferenceService = locator<ModelInferenceService>();
    _initStateAsync();
    super.initState();

    // _initializeControllerFuture = _initalizeCamera();
    _getUser();
  }

  void _initStateAsync() async {
    _isolateUtils = IsolateUtils();
    await _isolateUtils.initIsolate();
    await _initCamera();
    _predicting = false;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _isolateUtils.dispose();
    _modelInferenceService.inferenceResults = null;
    super.dispose();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraDescription = _cameras[1];
    _isRun = false;
    _onNewCameraSelected(_cameraDescription);
  }

  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _cameraController!.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController!.value.hasError) {
        _showInSnackBar(
            'Camera error ${_cameraController!.value.errorDescription}');
      }
    });

    try {
      await _cameraController!.initialize().then((value) {
        if (!mounted) return;
      });
    } on CameraException catch (e) {
      _showInSnackBar('Error: ${e.code}\n${e.description}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Future<void> _initalizeCamera() async {
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.firstWhere(
  //     (camera) => camera.lensDirection == CameraLensDirection.front,
  //   );

  //   _controller = CameraController(
  //     firstCamera,
  //     ResolutionPreset.medium,
  //   );

  //   // _initializeControllerFuture = _controller.initialize();
  //   await _controller.initialize();
  // }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _addReport() async {
    CollectionReference reports = FirebaseFirestore.instance
        .collection('User')
        .doc(_user.uid)
        .collection('Reports');
    await reports.add({
      'warning': true,
      'date': '2022-01-02',
      'start_driving_time': '00:00:00',
      'end_driving_time': '00:00:00',
      'time_stamp': '00:00:00, 00:00:00, 00:00:00',
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (_isRun) {
          _imageStreamToggle;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar,
        body: ModelCameraPreview(
          cameraController: _cameraController,
          draw: _draw,
        ),
        floatingActionButton: _buildFloatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  AppBar get _buildAppBar => AppBar(
        title: Text(
          "Driving",
          style: TextStyle(
              color: Colors.white,
              // fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.bold),
        ),
      );

  Row get _buildFloatingActionButton => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => _cameraDirectionToggle,
            color: Colors.white,
            // iconSize: ScreenUtil().setWidth(30.0),
            icon: const Icon(
              Icons.cameraswitch,
            ),
          ),
          IconButton(
            onPressed: () => _imageStreamToggle,
            color: Colors.white,
            // iconSize: ScreenUtil().setWidth(30.0),
            icon: const Icon(
              Icons.filter_center_focus,
            ),
          ),
        ],
      );

  void get _imageStreamToggle {
    setState(() {
      _draw = !_draw;
      print("_draw is true--------------------------------------");
    });
    print("imagestreamtoggle start!");
    _isRun = !_isRun;
    if (_isRun) {
      print("is running...--------------------------------------");
      _cameraController!.startImageStream(
        (CameraImage cameraImage) async =>
            await _inference(cameraImage: cameraImage),
      );
    } else {
      _cameraController!.stopImageStream();
    }
  }

  void get _cameraDirectionToggle {
    setState(() {
      _draw = false;
    });
    _isRun = false;
    if (_cameraController!.description.lensDirection ==
        _cameras.first.lensDirection) {
      _onNewCameraSelected(_cameras.last);
    } else {
      _onNewCameraSelected(_cameras.first);
    }
  }

  Future<void> _inference({required CameraImage cameraImage}) async {
    print("i'm inference function...");
    if (!mounted) {
      return;
    }
    // if (_modelInferenceService.model == null) {
    //   print("model is null-----------------------------------");
    // }
    if (_modelInferenceService.model.getInterpreter != null) {
      if (_predicting || !_draw) {
        return;
      }

      setState(() {
        _predicting = true;
      });
      // print("predicting start!-----------------------------------");

      if (_draw) {
        print("before calling inference------------------------------");
        await _modelInferenceService.inference(
          isolateUtils: _isolateUtils,
          cameraImage: cameraImage,
        );
      }

      setState(() {
        _predicting = false;
      });
    }
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder<void>(
  //       future: _initializeControllerFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           return Stack(
  //             children: <Widget>[
  //               CameraPreview(_controller),
  //               Positioned(
  //                 left: 0,
  //                 bottom: 0,
  //                 child: FloatingActionButton(
  //                     child: Icon(Icons.stop),
  //                     onPressed: () => handleStopClick(context)
  //                         ),
  //               ),
  //               Positioned(
  //                 right: 0,
  //                 bottom: 0,
  //                 child: FloatingActionButton(
  //                   child: Icon(Icons.pause),
  //                   onPressed: () {
  //                     _controller.pauseVideoRecording();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           );
  //         } else {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //       },
  //     ),
  //   );
  // }

  // void handleStopClick(BuildContext context) {
  //   try {
  //     print('Stop Clicked');
  //     _controller.dispose();
  //     _addReport();
  //     Navigator.of(context).pop();
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
