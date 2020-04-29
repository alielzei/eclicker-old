import 'package:eclicker/app/auth/auth_widget.dart';
import 'package:eclicker/app/auth/auth_widget_builder.dart';
import 'package:eclicker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'color.dart';

void main() => runApp(Eclicker());
class Eclicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AuthService(),
      child: AuthWidgetBuilder(
        builder: (context, userSnapshot){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: colorCustom,
              inputDecorationTheme: InputDecorationTheme(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
              )
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