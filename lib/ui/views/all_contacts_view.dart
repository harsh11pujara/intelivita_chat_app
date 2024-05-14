import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/user_model.dart';
import 'package:intelivita_chat_app/repository/chat_repository.dart';
import 'package:intelivita_chat_app/ui/components/profile_elemnts.dart';
import 'package:intelivita_chat_app/ui/views/chat_view.dart';
import 'package:intelivita_chat_app/view_models/chat_view_model.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class AllContactView extends StatefulWidget {
  const AllContactView({super.key});

  @override
  State<AllContactView> createState() => _AllContactViewState();
}

class _AllContactViewState extends State<AllContactView> {
  @override
  void initState() {
    super.initState();
    ChatViewModel chatProvider = context.read<ChatViewModel>();
    chatProvider.loadAllUserList();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userProvider = context.read<UserViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("All Contacts")),
      body: Consumer<ChatViewModel>(
        builder: (context, chatProvider, child) {
          List<UserModel> userList = chatProvider.allUsersList;
          userList.removeWhere((element) => element.id.toString() == userProvider.uid);
          return userList.isNotEmpty
              ? Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          debugPrint("user${userProvider.uid} peer${userList[index].id} ");
                          await ChatRepository()
                              .createChatRoom(userUid: userProvider.uid, peerUid: userList[index].id.toString())
                              .then((value) {
                            if (value != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatView(
                                      chatRoom: value,
                                      peer: userList[index],
                                    ),
                                  ));
                            } else {
                              // Fail to create room
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: profileElements(
                              title: userList[index].name.toString(),
                              subtitle: userList[index].email.toString(),
                              subtitleSize: 12,
                              tileColor: Colors.grey[200]),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
