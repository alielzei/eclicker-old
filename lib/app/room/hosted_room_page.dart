import 'package:eclicker/app/forms/create_session_form.dart';
import 'package:eclicker/app/session/hosted_session_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/room_service.dart';

// -Add loading screen when sining in
// -add there are no rooms/sessions/particiants
// -shil l submit bala options
// -get token

class HostedRoomPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final roomService = Provider.of<RoomService>(context, listen: false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(child: Text('Create Room'), onPressed: (){},)
          ],
          bottom: TabBar(tabs: [
            Tab(child: Text('Sessions')),
            Tab(child: Text('Participants')),
            Tab(child: Text('History')),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildSessions(context),
            _buildParticipants(context),
            Text('history')
            // rooms have history
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => CreateSessionForm(
                submitSession: roomService.createSession,
              )
            ));
          },
        ),
      ),
    );
  }

  Widget _buildSessionTile(BuildContext context, Session session){
    return Card(
      child: ListTile(
        // leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(session.title),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => HostedSessionPage()
          ));
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  Widget _buildParticipantTile(BuildContext context, String participant){
    return Card(
      child: ListTile(
        // leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(participant),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  Widget _buildParticipants(BuildContext context){
    return Consumer<RoomService>(
      builder: (context, roomService, child){
        if(roomService.participants == null){
          // this may throw error
          roomService.getParticipants();
          return Center(
            child: CircularProgressIndicator()
          );
        }

        return RefreshIndicator(
            child: ListView(
              children: roomService.participants.map(
                  (participant) => _buildParticipantTile(context, participant)).toList(),
            ),
            onRefresh: () => roomService.getParticipants(),
        );
      },
    );
  }

  Widget _buildSessions(BuildContext context){
    return Consumer<RoomService>(
      builder: (context, roomService, child){
        if(roomService.sessions == null){
          // this may throw error
          roomService.getSessions();
          return Center(
            child: CircularProgressIndicator()
          );
        }

        return RefreshIndicator(
            child: ListView(
              children: roomService.sessions.map(
                  (session) => _buildSessionTile(context, session)).toList(),
            ),
            onRefresh: () => roomService.getSessions(),
        );
      },
    );
  }
}