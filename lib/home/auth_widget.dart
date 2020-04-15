import 'package:eclicker/home/sign_in_page.dart';
import 'package:eclicker/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:eclicker/home/home_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    print(userSnapshot.connectionState);
    if(userSnapshot.connectionState == ConnectionState.active){
      return userSnapshot.hasData ? HomePage() : SignInPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}