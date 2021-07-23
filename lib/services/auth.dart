import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/model/AppUser.dart';

class AuthMethods {

  // FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
  // FirebaseAuth _auth = FirebaseAuth.instanceFor(app: secondaryApp);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  userFromFirebaseUser (User user) {
    if (user != null) {
      return AppUser(user.uid);
    } else {
      return null;
    }
  }
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      return userFromFirebaseUser(firebaseUser!);
    } catch(e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      return userFromFirebaseUser(firebaseUser!);
    } catch(e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }
}