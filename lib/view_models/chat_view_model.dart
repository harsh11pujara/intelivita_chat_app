import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/chat_repository.dart';

class ChatViewModel extends ChangeNotifier{
 Map<String, dynamic> allUsersList = {};

 Future<void> loadAllUserList() async {
   allUsersList = await ChatRepository().fetchAllUserList();
   notifyListeners();
 }
}