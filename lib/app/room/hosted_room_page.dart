import 'package:eclicker/app/forms/create_session_form.dart';
import 'package:eclicker/app/room/results_history_page.dart';
import 'package:eclicker/app/session/hosted_session_page.dart';
import 'package:eclicker/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/room_service.dart';

// -Add loading screen when sining in
// -add there are no rooms/sessions/particiants
// -shil l submit bala options
// -get token

class HostedRoomPage extends StatelessWidget {

  void _goToSession(BuildContext context, Session session){
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => ChangeNotifierProvider<SessionService>(
        create: (_) => SessionService(sessionId: session.id),
        child: HostedSessionPage(),
      )
    ));
  }

  void _goToHistory(BuildContext context, HistoryElement session){
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => SessionService(sessionId: session.id),
        child: OldResultsPage()
      )
    ));
  }

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
            _buildHistory(context),
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
          _goToSession(context, session);
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
  
  Widget _buildHistoryTile(BuildContext context, HistoryElement session){
    return Card(
      child: ListTile(
        // leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(session.title),
        onTap: (){
          _goToHistory(context, session);
        },
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
              children: [
                ...roomService.sessions.map(
                  (session) => _buildSessionTile(context, session)).toList(),
                  _copySessionToken(context)
                ],
            ),
            onRefresh: () => roomService.getSessions(),
        );
      },
    );
  }

  Widget _buildHistory(BuildContext context){
    return Consumer<RoomService>(
      builder: (context, roomService, child){
        if(roomService.history == null){
          // this may throw error
          roomService.getHistory();
          return Center(
            child: CircularProgressIndicator()
          );
        }

        return RefreshIndicator(
            child: ListView(
              children: roomService.history.map(
                (session) => _buildHistoryTile(context, session)).toList(),
            ),
            onRefresh: () => roomService.getHistory(),
        );
      },
    );
  }

  Widget _copySessionToken(BuildContext context){
    final roomService = Provider.of<RoomService>(context, listen: false);

    return RaisedButton(
      child: Text('Copy Room Token'),
      onPressed: (){
        Clipboard.setData(ClipboardData(text: roomService.room.id));
      },
    );
  }

}