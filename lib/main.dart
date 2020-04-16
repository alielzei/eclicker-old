import 'package:eclicker/app/auth/auth_widget.dart';
import 'package:eclicker/app/auth/auth_widget_builder.dart';
import 'package:eclicker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(Eclicker());

class Eclicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AuthService(),
      child: AuthWidgetBuilder(
        builder: (context, userSnapshot){
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey[100]
            ),
            home: Scaffold(
              body: Center(
                child: AuthWidget(userSnapshot: userSnapshot)
              )
            )
          );
        }
      ),
    );
  }
}