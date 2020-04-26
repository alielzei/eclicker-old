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
            child: _buildUserInfo(context)
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

  Widget _buildUserInfo(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child){       
        if(homeService.userName != null){
          
          return Column(
            children: <Widget>[
              _buildUSerInitials(homeService.userName),
              Text(homeService.userName, style: TextStyle(fontSize: 20))
            ],
          );
        }

        homeService.getUserName();
        return Center(child: CircularProgressIndicator());
      }
    );
  }
  
  Widget _buildUSerInitials(String userName){
    var x = userName.split(" ");
    var initials = x[0][0] + x[1][0];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 85.0,
        width: 85.0,
        color: Colors.transparent,
        child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[200],
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: new Center(
          child: new Text(initials, 
          style: TextStyle(color: Colors.white, fontSize: 30),
          textAlign: TextAlign.center,),
        )),
      ),
    );
  }

}