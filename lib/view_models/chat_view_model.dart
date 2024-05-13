import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/user_model.dart';
import 'package:provider/provider.dart';

import '../repository/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  // Map<String, dynamic> allUsersList = {};
  List<UserModel> allUsersList = [];

  Future<void> loadAllUserList() async {
    Map<String, dynamic> temp = await ChatRepository().fetchAllUserList();
    allUsersList = temp.values
        .map((e) => UserModel(id: e['id'], name: e['name'], email: e['email'], phone: e['phone'], fcmToken: e['fcmToken']))
        .toList();
    notifyListeners();
  }
}
