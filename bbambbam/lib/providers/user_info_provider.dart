import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  late String _uid;

  Map<String, dynamic>? get userInfo => _userInfo;
  bool get isLoading => _isLoading;

  UserInfoProvider() {
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      _uid = FirebaseAuth.instance.currentUser!.uid;
      var result =
          await FirebaseFirestore.instance.collection('User').doc(_uid).get();
      _userInfo = result.data();
      print('userInfo : ${_userInfo?['Name']}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print("Error fetching user info: $e");
      notifyListeners();
    }
  }

  Future<void> updateUserInfo(String field, String newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(_uid)
          .update({field: newValue});
      print("Updated user info: $field, $newValue");
      _userInfo?[field] = newValue;
      notifyListeners(); // Firestore 업데이트 후 상태 변경 알림
    } catch (e) {
      print("Error updating user info: $e");
    }
  }

  Future<void> refreshUserInfo() async {
    _isLoading = true;
    notifyListeners();
    await fetchUserInfo();
  }

  void clearUserInfo() {
    _userInfo = null;
    notifyListeners();
  }
}
