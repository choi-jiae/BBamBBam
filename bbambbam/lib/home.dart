import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Text(
                  'BBAM BBAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 350,
                height: 80,
                child: Text(
                  'Welcome to BBAM BBAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}