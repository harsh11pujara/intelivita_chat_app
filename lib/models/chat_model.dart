
import 'package:intelivita_chat_app/models/message_model.dart';

class ChatModel{
  String? chatRoomId;
  List? participants;
  String? lastMsgTime;
  List<MessageModel>? messages;

  ChatModel({required this.chatRoomId,required this.participants, required this.lastMsgTime, this.messages});

  ChatModel.fromJson(Map<String,dynamic> data){
    chatRoomId  = data["chatRoomId"];
    participants = data["participants"];
    lastMsgTime = data["lastMsgTime"] ;
    messages = data["messages"];
  }

  Map<String,dynamic> toMap() =>{
    "chatRoomId" : chatRoomId,
    "participants" : participants,
    "lastMsgTime" : lastMsgTime,
    "messages" : messages
  };
}