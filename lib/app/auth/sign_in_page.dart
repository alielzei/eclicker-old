import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eclicker/services/auth_service.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  Future<void> _signIn(context, {
    @required String email, 
    @required String password
  }) async {
    _setLoading(true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.signIn(email: email, password: password);
      print('uid ${user.uid}');
    } catch (e) {
      print(e);
    }
    _setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: _loading
      ? Center(child: CircularProgressIndicator())
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Host'),
            onPressed: () => _signIn(context,
              email: 'bdeir@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Ali'),
            onPressed: () => _signIn(context,
              email: 'ali@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Nariman'),
            onPressed: () => _signIn(context,
              email: 'nariman@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Nadine'),
            onPressed: () => _signIn(context,
              email: 'nadine@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Hussein'),
            onPressed: () => _signIn(context,
              email: 'hussein@eclicker.com',
              password: '123456'
            ),
          ),
        ],
      ),
    );
  }
}
