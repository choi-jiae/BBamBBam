import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  void _submitQuestion() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 여기서 _question 변수에 사용자가 입력한 질문이 저장됩니다.
      // 서버에 질문을 제출하는 로직을 추가하세요. 예를 들어, Firebase와의 통신 등.
      print('제출된 제목: $_title');
      print('제출된 내용: $_content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '1:1 문의',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // 스크롤 가능하게 만들어 줍니다.
          padding: EdgeInsets.all(16.0), // 폼 전체에 패딩 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼을 가로로 꽉 차게
            children: <Widget>[
              // 제목 입력 필드
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0), // 필드 사이에 간격 추가
                child: TextFormField(
                  decoration: InputDecoration(labelText: '제목'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
              ),
              // 내용 입력 필드
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // 필드 사이에 간격 추가
                child: TextFormField(
                  decoration: InputDecoration(labelText: '내용'),
                  maxLines: 5, // 내용 입력 필드를 다줄 입력으로 설정
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _content = value!;
                  },
                ),
              ),
              SizedBox(height: 40),
              // 제출 버튼
              TextButton(
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    child: Text('제출하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                        textAlign: TextAlign.center)),

                onPressed: _submitQuestion,
                // child: Text('제출하기',
                //     style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20,
                //         color: Colors.white),
                //     textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
