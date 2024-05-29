import 'package:flutter/material.dart';

class QNA extends StatefulWidget {
  const QNA({super.key});

  @override
  State<QNA> createState() => _QNAState();
}

class _QNAState extends State<QNA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '자주 묻는 질문',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text('질문 1: Flutter란 무엇인가요?'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('답변: Flutter는 구글이 개발한 모바일 앱 SDK입니다.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('질문 2: Flutter의 장점은 무엇인가요?'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('답변: Flutter의 장점으로는 빠른 개발 속도, 아름다운 UI, '
                    '하나의 코드 베이스로 여러 플랫폼을 지원한다는 점 등이 있습니다.'),
              ),
            ],
          ),
          // 추가 질문과 답변을 여기에 배치
        ],
      ),
    );
  }
}
