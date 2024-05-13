import 'package:firebase_database/firebase_database.dart';
import 'package:intelivita_chat_app/models/chat_model.dart';

class ChatRepository {

  Future<Map<String, dynamic>> fetchAllUserList() async {
    DataSnapshot data = await FirebaseDatabase.instance.ref("Users").get();
    Map<String, dynamic> users =  Map<String, dynamic>.from(data.value as Map);
    print(users);
    return users;
  }

  Future<ChatModel?> createChatRoom({required String userUid, required String peerUid}) async {
    ChatModel? data;
    String chatRoomId = userUid.compareTo(peerUid) > 0 ? userUid+peerUid : peerUid+userUid;
    ChatModel roomData = ChatModel(chatRoomId: chatRoomId, participants: [peerUid, userUid], lastMsgTime: "");
    var chatRoom = FirebaseDatabase.instance.ref("ChatRoom/$chatRoomId");
    DataSnapshot snapshot = await chatRoom.get();
    if(!snapshot.exists) {
      await chatRoom.set(roomData.toMap()).then((value) => data = roomData);
    } else {
      data = roomData;
    }
    return data;
  }
}
