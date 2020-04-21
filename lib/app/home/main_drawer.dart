import 'package:eclicker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: Text('John Doe')),
          ListTile(
            title: FlatButton(
              child: Text(
                'Sign out',
              ),
              onPressed: () => _signOut(context),
            )
          )
        ],
      ),
    );
  }
}