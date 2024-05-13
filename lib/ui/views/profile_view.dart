import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/repository/user_repository.dart';
import 'package:intelivita_chat_app/ui/components/profile_elemnts.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';

Widget profileView() {
  return Consumer<UserViewModel>(
    builder: (context, user, child) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          height: double.infinity,
          child: user.currentUser != null
              ? Column(
                  children: [
                    profileElements(title: "Name", subtitle: user.currentUser!.displayName.toString()),
                    profileElements(title: "Email", subtitle: user.currentUser!.email.toString()),
                    profileElements(
                        title: "Phone",
                        subtitle: user.currentUser!.phoneNumber != null ? user.currentUser!.phoneNumber.toString() : "-"),
                    Expanded(child: Container()),
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            await UserRepository().signOut();
                          },
                          child: const Text(
                            "SignOut",
                            style: TextStyle(color: Colors.red),
                          )),
                    )
                  ],
                )
              : const Center(
                  child: Text(
                    "Error Fetching User Data",
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ));
    },
  );
}
