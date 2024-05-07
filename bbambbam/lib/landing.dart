import 'dart:async';
import 'package:bbambbam/home.dart';
import 'package:bbambbam/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class landing extends StatefulWidget {
  const landing({super.key});

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // _permission();
      _auth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blue, child: const Center(child: Text("BBam BBam"))));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  _auth() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (FirebaseAuth.instance.currentUser == null) {
        //Get.to(Login());
        Navigator.of(context).pushNamed("/login");
      } else {
        //Get.to(Home());
        Navigator.of(context).pushNamed("/home");
      }
    });
  }

  _logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
