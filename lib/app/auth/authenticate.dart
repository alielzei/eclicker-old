import 'package:flutter/material.dart';
import 'package:eclicker/app/auth/sign_in_page.dart';
import 'package:eclicker/app/auth/sign_up_page.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignUp = true;

  void toggleView(){
    setState(() => _showSignUp = !_showSignUp);
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignUp){
      return SignInPage(toggleView: toggleView);
    }
    else{
      return SignUpPage(toggleView:toggleView);
    }
  }
}