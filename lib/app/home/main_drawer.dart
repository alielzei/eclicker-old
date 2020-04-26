import 'package:eclicker/app/home/email_service_page.dart';
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
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.contain,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                _buildUserName(context),
              ],
            )
          ),
          ListTile(
            title: FlatButton(
              child: Text(
                'Email Service',
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) =>EmailServicePage()
              )),
            )
          ),
          ListTile(
            title: FlatButton(
              child: Text(
                'Sign out',
              ),
              onPressed: () => _signOut(context),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child){
        if(homeService.userName != null)
          return Text(homeService.userName, style: TextStyle(fontSize: 20),);
        
        homeService.getUserName();
        return Center(child: CircularProgressIndicator());
      }
    );
  }

}