import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intelivita_chat_app/ui/views/home_view.dart';
import 'package:intelivita_chat_app/ui/views/login_view.dart';
import 'package:intelivita_chat_app/view_models/chat_view_model.dart';
import 'package:intelivita_chat_app/view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  showAwesomeNotification(message.data['title'], message.data['body']);
}

showAwesomeNotification(String title, String msg) async{
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecond,
      channelKey: 'basic_channel',
      title: title,
      body: msg,
      groupKey: "abc",
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: true,
      category: NotificationCategory.Message,
      locked: false,
      displayOnForeground: true,
    ),
    // actionButtons: [
    //   NotificationActionButton(
    //     key: 'accept',
    //     label: 'Accept',
    //   ),
    //   NotificationActionButton(
    //       isDangerousOption: true,
    //       key: 'reject',
    //       label: 'Reject',
    //       // autoDismissible: true,
    //       actionType: ActionType.SilentBackgroundAction
    //   ),
    // ],
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AwesomeNotifications().requestPermissionToSendNotifications();

  AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Message Notification',
            channelDescription: 'chat text',
            importance: NotificationImportance.High,
            channelShowBadge: true,
            vibrationPattern: highVibrationPattern
        ),
      ]
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((msg) {
    showAwesomeNotification(msg.data['title'], msg.data['body']);
  });

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
