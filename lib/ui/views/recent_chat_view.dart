import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/chat_model.dart';
import 'package:intelivita_chat_app/models/user_model.dart';
import 'package:intelivita_chat_app/ui/components/profile_elemnts.dart';
import 'package:intelivita_chat_app/ui/views/chat_view.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

Widget recentChatView(BuildContext context) {
  UserViewModel user = context.read<UserViewModel>();
  return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("ChatRoom")
            .orderByKey()
            .startAt(user.uid.toString())

            // .endBefore(user.uid.toString())
            .onValue,
        builder: (context, snapshot) {
          var snapshotData = snapshot.data;
          Map<String, dynamic> chatMap = Map<String, dynamic>.from((snapshotData?.snapshot.value ?? {}) as Map);
          List<ChatModel> chatRooms = [];
          for (var i in chatMap.values) {
            ChatModel chat = ChatModel(
              chatRoomId: i["chatRoomId"],
              participants: i["participants"],
              lastMsgTime: i["lastMsgTime"],
            );
            chatRooms.add(chat);
          }
          chatRooms.removeWhere((element) => !element.participants!.contains(user.uid.toString()));
          // print("length ${chatRooms.length}");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: chatRooms.length,

            itemBuilder: (context, index) {
              String peerUid = chatRooms[index].participants!.where((element) => element != user.uid).toList()[0];
              return FutureBuilder(
                future: FirebaseDatabase.instance.ref("Users/$peerUid").get(),
                builder: (context, userSnapshot) {
                  UserModel peer = UserModel.fromJson(Map<String, dynamic>.from((userSnapshot.data?.value ?? {}) as Map));
                  return InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatView(chatRoom: chatRooms[index], peer: peer),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: profileElements(
                          title: peer.name.toString(),
                          subtitle: peer.email.toString(),
                          subtitleSize: 12,
                          tileColor: Colors.grey[200]),
                    ),
                  );
                },
              );
            },
          );
        },
      ));
}
