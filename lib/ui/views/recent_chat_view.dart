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
          chatRooms.sort((a, b) => b.lastMsgTime.toString().compareTo(a.lastMsgTime.toString()));
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
                          subtitle: convertDateTime(chatRooms[index].lastMsgTime),
                          subtitleSize: 12,
                          subtitleAlignment: Alignment.centerRight,
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

String convertDateTime(String? date) {
  if (date == null || date == "" || date == " ") {
    return '';
  } else {
    print("date time $date 1");
    DateTime time = DateTime.parse(date);
    Duration difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) {
      return "Just Now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays <= 7) {
      return "${difference.inDays} days ago";
    } else {
      return formatDate(time);
    }
  }
}

String formatDate(DateTime dateTime) {
  // Get day, month, year
  String day = dateTime.day.toString();
  String month = getMonthName(dateTime.month);
  String year = dateTime.year.toString();

  // Get hour, minute
  String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');

  // Get AM/PM
  String period = dateTime.hour < 12 ? 'AM' : 'PM';

  // Format the date
  return '$day $month $year $hour:$minute $period';
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}
