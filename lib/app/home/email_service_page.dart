import 'package:flutter/material.dart';

class EmailServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Email Service', 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
"""In order to do so you can send an email message to the following address:\n
sfueokfb@mailparser.io\n
with your room token as you can now create a session using any txt file without using your phone,\n
you just put the session information in a txt file using the following format:\n
title: Title
options: option1, option2, option3\n
and email it to with your room token only as email subject """,
              style: TextStyle(
                fontSize: 20
              )),
            )
          ],
        ),
      )
    );
  }
}