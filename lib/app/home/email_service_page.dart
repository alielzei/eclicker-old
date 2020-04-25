import 'package:flutter/material.dart';

class EmailServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(), 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Info about email service', style: Theme.of(context).textTheme.title,),
          Text("""In order to do so you can send an email message to the following address sfueokfb@mailparser.io with your room token as you can now create a session using any txt file without using your phone, you just put the session information in a txt file using the following format: title: this is a question options : option1,option2,option3 and email it to the following address  sfueokfb@mailparser.io with your room token only as email subject """
          )
        ]
      )
    );
  }
}