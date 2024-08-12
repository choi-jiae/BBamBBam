import 'package:flutter/material.dart';

class ReportItem extends StatelessWidget {
  final Map<String, dynamic> report;
  const ReportItem(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 210, 210, 210),
                blurRadius: 5,
                spreadRadius: 1)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: [
            Icon(
              report['warning'] ? Icons.warning : Icons.check_circle,
              color: report['warning'] ? Colors.red : Colors.green,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              report['warning'] ? '졸음운전 감지' : '정상운전',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            // Text(
            //   '운전 날짜 ${report['date']}',
            //   style: const TextStyle(
            //       color: Colors.black54,
            //       fontSize: 20,
            //       fontWeight: FontWeight.normal),
            // ),
            ],),
            const SizedBox(height: 10),
            Text(
              '총 운전 시간: ${report['total']}',
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Text(
              '졸음운전 위험 횟수: ${report['count']}',
              style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
            ),
            ...report['timestamp'].map((timestamp) {
              return Text(
                timestamp,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              );
            }).toList(),

          ],
        ),
      );
      
     
    
  }
}
