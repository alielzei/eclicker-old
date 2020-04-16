import 'package:flutter/material.dart';

import 'package:eclicker/app/room/room_page.dart';

class CreateRoomForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('again'),
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => RoomPage(roomID: 'saucy_id_here',)
            ));
          },
        )
      )
    );
  }
}