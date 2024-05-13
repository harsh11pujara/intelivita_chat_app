
class MessageModel{
  String? msgId;
  String? msg;
  String? senderId;
  String? createdOn;
  String? msgType;

  MessageModel({required this.msgType, required this.msg, required this.msgId, required this.senderId, required this.createdOn});

  MessageModel.fromJson(Map<String, dynamic> data){
    msgId = data["msgId"];
    msg = data["msg"];
    senderId = data["senderId"];
    createdOn = data["createdOn"];
    msgType = data["msgType"];
  }

  Map<String, dynamic> toMap() => {
    "msgId" : msgId,
    "msg" : msg,
    "senderId" : senderId,
    "createdOn" : createdOn,
    "msgType" : msgType,
  };
}