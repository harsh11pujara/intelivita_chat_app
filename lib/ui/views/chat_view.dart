import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: ListView.builder(itemBuilder: (context, index) {
            return Container();
          },)),
          Row(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                ),
              ),
              FloatingActionButton(onPressed: () {},child: const Icon(Icons.send),)
            ],
          )
        ],
      ),
    );
  }
}
