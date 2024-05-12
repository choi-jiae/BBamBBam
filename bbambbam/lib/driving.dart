import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbambbam/home.dart';


class Driving extends StatefulWidget {
  const Driving({super.key});

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late User _user;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initalizeCamera();
    _getUser();
  }

  Future<void> _initalizeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _addReport() async{
    if (_user != null ) {
      CollectionReference reports = 
        FirebaseFirestore.instance.collection('User').doc(_user.uid).collection('Reports');
      await reports.add(
        {
          'warning': true,
          'date': '2022-01-02',
          'start_driving_time': '00:00:00',
          'end_driving_time': '00:00:00',
          'time_stamp': '00:00:00, 00:00:00, 00:00:00',
        }
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: <Widget>[
              CameraPreview(_controller),
              Positioned(
                left: 0,
                bottom: 0,
                child: FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () => handleStopClick(context)
                  
                  ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton(
                  child: Icon(Icons.pause),
                  onPressed: (){
                    _controller.pauseVideoRecording();
                  },
                  ),
              ),
            ],
          );
          
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      ),
    );

  }

    void handleStopClick(BuildContext context) {
      try {
        _controller.dispose();
        _addReport();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home())
        );
      } catch (e) {
        print('Error: $e');
      }
    }

  }
