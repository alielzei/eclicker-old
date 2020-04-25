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
          Text('You can create sessions using our email service')
        ]
      )
    );
  }
}