import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/repository/user_repository.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Welcome to Intelivita Chat App", textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24),),
              InkWell(
                onTap: () async {
                  // SignIN with Google
                  await UserRepository().signInWithGoogle().then((value) async {
                    if (value != null) {
                      await UserRepository().createUserOnDB(value.user);
                    }
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(border: Border.all(width: 2,), borderRadius: BorderRadius.circular(18)),
                  child: const Center(child: Text("Signin with Google", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
