import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/ui/views/home_view.dart';
import 'package:intelivita_chat_app/ui/views/login_view.dart';
import 'package:intelivita_chat_app/view_models/chat_view_model.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserViewModel>(
        create: (context) => UserViewModel(),
      ),
      ChangeNotifierProvider<ChatViewModel>(
        create: (context) => ChatViewModel(),
      )
    ],
    child: const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        User? user = snapshot.data;
        debugPrint(user?.toString());
        if (user != null) {
          if (mounted) {
            UserViewModel userProvider = context.read<UserViewModel>();
            userProvider.setUserDetails(user);
            return const HomeView();
          }
        } else {
          if (mounted) {
            return const LoginView();
          }
        }
        return const LoginView();
      },
    );
  }
}
