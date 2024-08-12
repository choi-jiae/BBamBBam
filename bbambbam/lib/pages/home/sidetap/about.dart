import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'About BBAM BBAM',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            child: Text(
              'BBAM BBAM',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
          Container(
            margin: EdgeInsets.all(10),
            child:
              Text('''BBAM BBAM은 운전자들을 위한 졸음운전 방지 어플리케이션입니다.''',
                style: TextStyle(
                  fontSize: 18,
                )
          ),),
          Container(
            margin: EdgeInsets.all(10),
            child:  Text(
              ''' 운전자의 얼굴을 인식하여 졸음을 감지하고, 졸음이 감지되면 BBAM BBAM의 캐릭터 빼미가 등장하고 경고음을 울립니다. 운전 시 촬영되는 동영상은 어디에도 저장되지 않습니다. ''',
              style: TextStyle(
                fontSize: 18,
              ),
          ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child:  Text(
              ''' 빼미와 함께 안전한 운전을 즐기세요!''',
              style: TextStyle(
                fontSize: 18,
              ),
          ),
          )

      ],
    )
    );
  }
}  