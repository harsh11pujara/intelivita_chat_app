import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/chat_model.dart';
import 'package:intelivita_chat_app/models/message_model.dart';
import 'package:intelivita_chat_app/models/user_model.dart';
import 'package:intelivita_chat_app/utils/show_snackbar.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatRoom, required this.peer});

  final ChatModel chatRoom;
  final UserModel peer;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserViewModel user = context.read<UserViewModel>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        title: Text(widget.peer.name.toString()),
        elevation: 1,
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref("ChatRoom/${widget.chatRoom.chatRoomId}/messages")
                  .onValue,
              builder: (context, snapshot) {
                DatabaseEvent? event = snapshot.data;
                List<DataSnapshot>? snapshotList = event?.snapshot.children.toList();
                List<MessageModel> messages = [];
                if (snapshotList != null) {
                  for (DataSnapshot i in snapshotList) {
                    messages.add(MessageModel.fromJson(Map<String, dynamic>.from(i.value as Map)));
                  }
                }
                messages.sort((a, b) {
                  return DateTime.parse(b.createdOn.toString()).compareTo(DateTime.parse(a.createdOn.toString()));
                },);
                return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        bool isUser = messages[index].senderId == user.uid ? true : false;
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            // height: 30,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                            decoration: BoxDecoration(
                                border: isUser ? Border.all() : null,
                                borderRadius: BorderRadius.only(
                                    topLeft: !isUser ? Radius.zero : const Radius.circular(8),
                                    topRight: isUser ? Radius.zero : const Radius.circular(8),
                                    bottomRight: const Radius.circular(8),
                                    bottomLeft: const Radius.circular(8)
                                ),
                                color: isUser ? Colors.white70 : Colors.purple[100]
                            ),
                            child: Text(messages[index].msg.toString()),
                          ),
                        );
                      },
                    ));
              },
            ),
            Container(
              height: 52,
              margin: const EdgeInsets.only(bottom: 10, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(contentPadding: const EdgeInsets.only(bottom: 8, top: 8, left: 16),
                          hintText: "Type Here..",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      //send messages
                      if (messageController.text
                          .trim()
                          .isNotEmpty) {
                        String msgId = math.Random().nextInt(4294967296).toString();
                        MessageModel message = MessageModel(
                            msgType: "Text",
                            msg: messageController.text.trim(),
                            msgId: msgId,
                            senderId: user.uid.toString(),
                            createdOn: DateTime.now().toIso8601String());
                        messageController.clear();
                        try {
                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref("ChatRoom/${widget.chatRoom.chatRoomId}/messages");
                          if (ref.key != null) {
                            await ref.update({msgId: message.toMap()}).then((value) async {
                              await sendNotificationToOtherUsers(targetUserToken: widget.peer.fcmToken.toString(),
                                  message: messageController.text.trim(),
                                  userName: user.currentUser!.displayName.toString());
                            });
                          } else {
                            await ref.set({msgId: message.toMap()}).then((value) async {
                              await sendNotificationToOtherUsers(targetUserToken: widget.peer.fcmToken.toString(),
                                  message: messageController.text.trim(),
                                  userName: user.currentUser!.displayName.toString());
                            });
                          }
                          messageController.clear();
                        } on Exception catch (e) {
                          showSnackBar(context, "Unable to send message");
                        }
                      }
                    },
                    backgroundColor: Colors.purple[100],
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendNotificationToOtherUsers(
      {required String targetUserToken, required String message, required String userName}) async {
    try {
      String serverKey =
          "AAAAU7ISpi0:APA91bGrGilyzM90dq5bBmKaTlvX5i9YEV1AL03LoSIJXPYr0bEKMnEjcAWJcxDo_1D_swlTBJ4hs7Vkn861o87AfIa1MXkr-zCimnBt3RcyQPsLoGVoe_MdmGr2T08yBpLPIrmY0FVl"; // You can find this key in the Firebase Console under "Project settings" -> "Cloud Messaging"
      String url = 'https://fcm.googleapis.com/fcm/send';

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      };

      Map<String, dynamic> data = {
        'to': targetUserToken,
        'data': {
          'title': userName,
          'body': message,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK', // Optional, customize the action when the user taps the notification
        },
      };

      String body = jsonEncode(data);

      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully.');
      } else {
        debugPrint('Failed to send notification. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }
}
