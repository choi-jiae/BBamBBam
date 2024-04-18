import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: const IconButton(
          icon: Icon(Icons.menu, color: Colors.white, size: 30),
          onPressed: null // hamburger menu 연결하기
          ),
          title: const Text('BBAM BBAM', 
            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset('assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            ),
          Positioned(
            top: 340,
            left: 65,
            child: GestureDetector(
              onTap: () {
                
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
      bottomSheet: Container(
        height:100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
        ),
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
            Center(child: Text('bottom sheet'),)
          ],)
        
      ),

    );
  }
}