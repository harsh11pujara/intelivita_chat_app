
class ChatModel{
  String? chatRoomId;
  List? participants;
  String? lastMsgTime;

  ChatModel({required this.chatRoomId,required this.participants, required this.lastMsgTime});

  ChatModel.fromJson(Map<String,dynamic> data){
    chatRoomId  = data["chatRoomId"];
    participants = data["participants"];
    lastMsgTime = data["lastMsgTime"] ;
  }

  Map<String,dynamic> toMap() =>{
    "chatRoomId" : chatRoomId,
    "participants" : participants,
    "lastMsgTime" : lastMsgTime,
  };
}