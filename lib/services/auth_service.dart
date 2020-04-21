import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({@required this.uid});
  final String uid;
}

class AuthService {
  final _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signIn({
    @required String email,
    @required String password
  }) async {
    AuthResult authResult 
      = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
