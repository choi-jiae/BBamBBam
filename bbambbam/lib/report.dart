import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height, // 화면 높이만큼 설정
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
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
              Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text('📑 운전 리포트', style: TextStyle(color:Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),),) 
              )
            ],
          ),
        );
  }
}