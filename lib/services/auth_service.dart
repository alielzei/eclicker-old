import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

@immutable
class User {
  const User({@required this.uid});
  final String uid;
}

class AuthService {
  final _auth = FirebaseAuth.instance;

  String uid;
  
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
    try{
      AuthResult authResult 
        = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(authResult.user);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<User> signUp({
    @required String first,
    @required String last,
    @required String email,
    @required String password
  }) async {
    try{
      AuthResult authResult 
        = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      Firestore.instance.collection('users')
        .document(authResult.user.uid).setData({'email': email, 'name': '$first $last'});

      return _userFromFirebase(authResult.user);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

}
