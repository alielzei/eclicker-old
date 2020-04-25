import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eclicker/services/session_service.dart';
import 'package:eclicker/services/room_service.dart';

import 'package:eclicker/app/session/joined_session_page.dart';

class JoinedRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(child: Text('Create Room'), onPressed: (){},)
          ],
        ),
        body: _buildActiveSessions(context),
      );
  }

  void _goToSession(BuildContext context, Session session){
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => ChangeNotifierProvider<SessionService>(
        create: (_) => SessionService(sessionId: session.id),
        child: JoinedSessionPage(),
      )
    ));
  }

  Widget _buildSessionTile(BuildContext context, Session session){
    return Card(
      child: ListTile(
        // leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(session.title),
        onTap: () => _goToSession(context, session),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  Widget _buildActiveSessions(BuildContext context){
    return Consumer<RoomService>(
      builder: (context, roomService, child){
        if(roomService.activeSessions != null)
          return RefreshIndicator(
            child: ListView(
              children: roomService.activeSessions.length > 0
              ? roomService.activeSessions.map(
                (session) => _buildSessionTile(context, session)).toList()
              : _emptyAlert(context, 'There are no active sessions right now'),
            ),
            onRefresh: () => roomService.getActiveSession(),
          );

        roomService.getActiveSession();
        return Center(
          child: CircularProgressIndicator()
        );
      },
    );
  }

  List<Widget> _emptyAlert(BuildContext context, String text){
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text(text)),
      )
    ];
  }
  
}