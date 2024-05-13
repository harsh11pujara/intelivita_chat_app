import 'package:firebase_database/firebase_database.dart';

class ChatRepository {

  Future<Map<String, dynamic>> fetchAllUserList() async {
    DataSnapshot data = await FirebaseDatabase.instance.ref("Users").get();
    Map<String, dynamic> users =  Map<String, dynamic>.from(data.value as Map);
    print(users);
    return users;
  }
}
