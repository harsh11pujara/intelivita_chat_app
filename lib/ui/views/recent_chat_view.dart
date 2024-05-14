import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/chat_model.dart';
import 'package:intelivita_chat_app/models/message_model.dart';
import 'package:intelivita_chat_app/ui/components/profile_elemnts.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

Widget recentChatView(BuildContext context) {
  UserViewModel user = context.read<UserViewModel>();
  print("user uid ${user.uid.toString()}");
  return Container(
      height: double.infinity,
      width: double.infinity,
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
          print("recent $chatMap");
          List<ChatModel> chatRooms = [];
          for (var i in chatMap.values) {
            ChatModel chat = ChatModel(chatRoomId: i["chatRoomId"],
                participants: i["participants"],
                lastMsgTime: i["lastMsgTime"],
              );
            chatRooms.add(chat);
          }
          chatRooms.removeWhere((element) => !element.participants!.contains(user.uid.toString()));
          print("length ${chatRooms.length}");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {

                },
                child: profileElements(
                    title: "userList[index].name.toString()", subtitle: "userList[index].email.toString()", subtitleSize: 14),
              );
            },
          );
        },
      )
  );
}