
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {

  Stream<User?> checkUserLoginStatus() {
    return FirebaseAuth.instance.authStateChanges().asBroadcastStream();
  }

  Future<void> createUserOnDB(User? currentUser) async {
    if (currentUser != null) {
      Map<String, dynamic> data = {
        "name" : currentUser.displayName.toString(),
        "email" : currentUser.email.toString(),
        "phone" : currentUser.phoneNumber.toString(),
        "id" : currentUser.uid.toString(),
        "fcmToken" : await FirebaseMessaging.instance.getToken()
      };
      await FirebaseDatabase.instance.ref("Users/${currentUser.uid}").set(data);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseException catch (e) {
      // TODO
      print('exception->$e');
      print('exception->${e.message}');

    }
    return null;
  }

  Future<void> signOut() async{
    await GoogleSignIn().signOut().then((value) async {
      await FirebaseAuth.instance.signOut();
    });
  }
}