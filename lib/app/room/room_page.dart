import 'package:flutter/material.dart';

import 'package:eclicker/services/home_service.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({Key key, @required this.roomID}) : super(key: key);
  final String roomID;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('will get room $roomID')
      )
    );
  }
}