import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/models/chat_model.dart';
import 'package:intelivita_chat_app/models/user_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatRoom, required this.peer});
  final ChatModel chatRoom;
  final UserModel peer;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(leadingWidth: 50, title: Text(widget.peer.name.toString()), elevation: 1,),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(child: ListView.builder(shrinkWrap: true, itemCount: 5,itemBuilder: (context, index) {
              return Container(height: 30,);
            },)),
            Container(
              height: 55,
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  FloatingActionButton(onPressed: () {},child: const Icon(Icons.send),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
