import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/ui/views/profile_view.dart';
import 'package:intelivita_chat_app/ui/views/recent_chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(index == 0 ? "Recent Chats" : "Profile")),
      body: index == 0 ? recentChatView() : profileView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person_sharp), label: "Profile"),
      ],
        onTap: (value) {
          index = value;
          setState(() {});
        },
      ),
    );
  }
}
