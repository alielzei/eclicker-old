import 'package:eclicker/services/auth_service.dart';
import 'package:eclicker/services/home_service.dart';
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
          DrawerHeader(
            child: Center(
              child: Consumer<HomeService>(
              builder: (context, homeService, child){
                if(homeService.userName != null)
                  return Text(homeService.userName, style: TextStyle(fontSize: 20),);
                
                homeService.getUserName();
                return Center(child: CircularProgressIndicator());
              }
            ))
          ),
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