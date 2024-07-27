import 'package:bbambbam/providers/driving_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:provider/provider.dart';
import 'detector_view.dart';
import 'painters/face_mesh_detector_painter.dart';
import 'dart:math';

class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  late String uid;
  late DateTime nowDate;
  late String formattedDate;
  final FaceMeshDetector _meshDetector =
      FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
  bool _canProcess = true;
  bool _isBusy = false;
  int _sleepCount = 0;
  final List<String> _sleepTimes = [];
  DateTime? _eyesClosedStartTime;
  CustomPaint? _customPaint;
  String? _text;
  bool _showImage = false;
  var _cameraLensDirection = CameraLensDirection.front;

  late Map<String, dynamic> _drivingRecord;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    nowDate = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(nowDate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final drivingRecordProvider =
          Provider.of<DrivingRecord>(context, listen: false);
      drivingRecordProvider.updateField('date', formattedDate);
      _drivingRecord = drivingRecordProvider.drivingRecord;
    });
  }

  @override
  void dispose() {
    _canProcess = false;
    _meshDetector.close();
    _handleDispose();
    super.dispose();
  }

  Future<void> _handleDispose() async {
    await addDrivingRecord(uid, _drivingRecord);
  }

  Future<void> addDrivingRecord(
      String uid, Map<String, dynamic> drivingRecord) async {
    try {
      DocumentReference userReportRef =
          FirebaseFirestore.instance.collection('Report').doc(uid);

      await userReportRef.set({
        'drivingRecords': FieldValue.arrayUnion([drivingRecord]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Driving record added for user: $uid');
    } catch (e) {
      print('Error adding driving record: $e');
    }
  }

  num euclideanDistance(num x1, num y1, num x2, num y2) {
    var point1 = Point(x1, y1);
    var point2 = Point(x2, y2);
    return point1.distanceTo(point2);
  }

  void _showBbami() async {
    setState(() {
      _showImage = true;
    });

    List<String> audioFiles = [
      'data/get_up.mp3',
      'data/fighting.mp3',
      'data/open_your_eyes.mp3',
    ];

    final random = Random();
    String randomAudioFile = audioFiles[random.nextInt(audioFiles.length)];

    final player = AudioPlayer();
    player.play(AssetSource(randomAudioFile));

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showImage = false;
      });
    });
  }

  void setDrivingRecord(List<String> timeStamp, num count) {
    final drivingRecordProvider =
        Provider.of<DrivingRecord>(context, listen: false);
    drivingRecordProvider.updateField('timestamp', timeStamp);
    drivingRecordProvider.updateField('count', count);
    drivingRecordProvider.updateField('warning', true);
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final meshes = await _meshDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceMeshDetectorPainter(
        meshes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);

      double leftEAR = 0.0;
      double rightEAR = 0.0;

      for (final mesh in meshes) {
        List<FaceMeshPoint>? leftEyePoints =
            mesh.contours[FaceMeshContourType.leftEye];
        List<FaceMeshPoint>? rightEyePoints =
            mesh.contours[FaceMeshContourType.rightEye];

        if (leftEyePoints != null) {
          var leftEar1 = euclideanDistance(leftEyePoints[3].x,
              leftEyePoints[3].y, leftEyePoints[13].x, leftEyePoints[13].y);
          var leftEar2 = euclideanDistance(leftEyePoints[5].x,
              leftEyePoints[5].y, leftEyePoints[11].x, leftEyePoints[11].y);
          var leftEar3 = euclideanDistance(leftEyePoints[0].x,
              leftEyePoints[0].y, leftEyePoints[8].x, leftEyePoints[8].y);

          leftEAR = (leftEar1 + leftEar2) / (2.0 * leftEar3);
        }

        if (rightEyePoints != null) {
          var rightEar1 = euclideanDistance(rightEyePoints[3].x,
              rightEyePoints[3].y, rightEyePoints[13].x, rightEyePoints[13].y);
          var rightEar2 = euclideanDistance(rightEyePoints[5].x,
              rightEyePoints[5].y, rightEyePoints[11].x, rightEyePoints[11].y);
          var rightEar3 = euclideanDistance(rightEyePoints[0].x,
              rightEyePoints[0].y, rightEyePoints[8].x, rightEyePoints[8].y);

          rightEAR = (rightEar1 + rightEar2) / (2.0 * rightEar3);
        }

        var ear = (leftEAR + rightEAR) / 2.0;
        if (ear < 0.2) {
          _eyesClosedStartTime ??= DateTime.now();
        } else {
          _eyesClosedStartTime = null;
        }
      }

      if (_eyesClosedStartTime != null) {
        var nowTime = DateTime.now();
        var duration = nowTime.difference(_eyesClosedStartTime!);

        if (duration.inSeconds > 0.5) {
          print("졸음 운전 감지");
          _eyesClosedStartTime = null;
          _sleepCount += 1;
          _sleepTimes.add(DateFormat('HH:mm:ss').format(nowTime));
          setDrivingRecord(_sleepTimes, _sleepCount);
          print(_sleepCount);
          print(_sleepTimes);
          _showBbami();
        }
      }
    } else {
      String text = 'Face meshes found: ${meshes.length}\n\n';
      for (final mesh in meshes) {
        text += 'face: ${mesh.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DetectorView(
          title: 'Face Mesh Detection',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        ),
        Visibility(
          visible: _showImage,
          child: Center(
            child: Image.asset('assets/images/bbam.png'),
          ),
        ),
      ],
    );
  }
}
