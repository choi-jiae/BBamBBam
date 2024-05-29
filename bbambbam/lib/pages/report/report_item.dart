import 'package:flutter/material.dart';

class ReportItem extends StatelessWidget {
  final Map<String, dynamic> report;
  const ReportItem(this.report, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${report['warning']? '🚨':'✅'}${report['date']}', style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),),
            Text('운전 시간 ${report['start_driving_time']} ~ ${report['end_driving_time']}', style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),),
            Text('졸음 운전 감지', style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),),
            Text('${report['time_stamp']}', style: const TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),),
            SizedBox(height: 15,),
            const Divider(color: Colors.grey, height: 20, thickness: 1, indent: 20, endIndent: 20),
          ],
      ),
    );
  }
}