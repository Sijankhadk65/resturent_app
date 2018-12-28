import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth{
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<FirebaseUser> currentUser();
}


class Auth implements BaseAuth{
  @override
  Future<FirebaseUser> currentUser() {
    // TODO: implement currentUser
    return FirebaseAuth.instance.currentUser();
  }

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    // TODO: implement signInWithEmailAndPassword
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    return user.email;
  }

}