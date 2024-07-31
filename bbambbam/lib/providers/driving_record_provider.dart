import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrivingRecord with ChangeNotifier {
  Map<String, dynamic> _drivingRecord = {
    'date': '',
    'count': 0,
    'timestamp': [],
    'total': '00:00:00',
    'warning': false,
  };

  Map<String, dynamic> get drivingRecord => _drivingRecord;

  void updateDrivingRecord(Map<String, dynamic> newRecord) {
    _drivingRecord = newRecord;
    notifyListeners(); // 상태 변경 알림
  }

  Future<void> updateField(String key, dynamic value) async{
    _drivingRecord[key] = value;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void reset() {
    _drivingRecord = {
      'date': '',
      'count': 0,
      'timestamp': [],
      'total': '',
      'warning': false,
    };
    notifyListeners();
  }
}
