import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bbambbam/pages/driving/driving.dart';
import 'package:bbambbam/pages/report/report.dart';
import 'package:bbambbam/pages/home/sidetap/sidetap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _showFullBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const Report();
      },
      isScrollControlled: true, // 풀 스크린을 위한 설정
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        // leading: const IconButton(
        //     icon: Icon(Icons.menu, color: Colors.white, size: 30),
        //     onPressed: null // hamburger menu 연결하기
        //     ),
        title: const Text(
          'BBAM BBAM',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Sidetap(),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          // Positioned(
          //   top: 340,
          //   left: 65,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const Driving()),
          //       );
          //     },
          //     child: Image.asset(
          //       'assets/images/handle.png',
          //       width: 300,
          //       height: 300,
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment(0, 0.15), // 이 값을 조절하여 위치를 정확히 조정하세요.
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Driving()),
                );
              },
              child: Image.asset(
                'assets/images/handle.png',
                width: 300,
                height: 300,
              ),
            ),
          )
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: () => _showFullBottomSheet(context),
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 0) {
            // 위로 swipe
            _showFullBottomSheet(context);
          }
        },
        child: Container(
            height: 100,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Column(
              children: <Widget>[
                Container(
                  height: 5,
                  width: 50,
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        '📑 운전 리포트',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
