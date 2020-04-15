import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eclicker/services/auth_service.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signIn(context, {
    @required String email, 
    @required String password
  }) async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.signIn(email: email, password: password);
      print('uid ${user.uid}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Host (bdeir)'),
            onPressed: () => _signIn(context,
              email: 'bdeir@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Respondent (ali)'),
            onPressed: () => _signIn(context,
              email: 'ali@eclicker.com',
              password: '123456'
            ),
          ),
        ],
      ),
    );
  }
  
}
