import 'package:eclicker/services/auth_service.dart';
import 'package:eclicker/services/home_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    return StreamBuilder(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot){
        final user = snapshot.data;
        return user == null
        ? builder(context, snapshot)
        : MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => HomeService(uid: user.uid)
            ),
            Provider<AuthService>(
              create: (_) => AuthService()
            )
          ],
          child: builder(context, snapshot),
        );
      }
    );
  }
}