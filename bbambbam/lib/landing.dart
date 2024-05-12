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

class _landingState extends State<landing> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    // _permission();
    _controller!.forward().then((_) {
      _auth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 색상 흰색
      body: Center(
        child: FadeTransition(
          opacity: _animation!, // 페이드 애니메이션 적용
          child: Text(
            'BBAM BBAM',
            style: TextStyle(
              fontSize: 40, // 글자 크기
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold, // 글자 색상 파란색
            ),
          ),
        ),
      ),
    );

    // Scaffold(
    //     body: Container(
    //         color: Colors.blue, child: const Center(child: Text("BBam BBam"))));
  }

  @override
  void dispose() {
    _controller!.dispose();
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
