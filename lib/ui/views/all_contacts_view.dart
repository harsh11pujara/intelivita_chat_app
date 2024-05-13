import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/ui/components/profile_elemnts.dart';
import 'package:intelivita_chat_app/ui/views/chat_view.dart';
import 'package:intelivita_chat_app/view_models/chat_view_model.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Contacts")),
      body: Consumer<ChatViewModel>(
        builder: (context, chatProvider, child) {
          Map<String, dynamic> userList = chatProvider.allUsersList;
          List valueList = userList.values.toList();
          return userList.isNotEmpty
              ? Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatView(),));
                        },
                        child: profileElements(
                            title: valueList[index]["name"], subtitle: valueList[index]["email"], subtitleSize: 14),
                      );
                    },
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
