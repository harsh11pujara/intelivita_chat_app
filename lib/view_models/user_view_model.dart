import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  User? currentUser;
  User? get getUserDetails => currentUser;

  void setUserDetails(User details) {
    currentUser = details;
    // notifyListeners();
  }
}