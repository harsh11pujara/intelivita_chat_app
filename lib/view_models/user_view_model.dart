import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  User? currentUser;
  String uid = "";
  User? get getUserDetails => currentUser;

  void setUserDetails(User details) {
    currentUser = details;
    uid = details.uid;
  }

}