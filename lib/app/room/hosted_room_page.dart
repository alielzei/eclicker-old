import 'package:eclicker/app/forms/create_session_form.dart';
import 'package:eclicker/app/session/results_history_page.dart';
import 'package:eclicker/app/session/hosted_session_page.dart';
import 'package:eclicker/services/home_service.dart';
import 'package:eclicker/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/room_service.dart';

class HostedRoomPage extends StatefulWidget {

  @override
  _HostedRoomPageState createState() => _HostedRoomPageState();
}

class _HostedRoomPageState extends State<HostedRoomPage> {

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

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
          title: Text('Room'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.delete), onPressed: (){
              _setLoading(true);
              roomService.deleteRoom().then((v){
                Navigator.pop(context);
              })  
              .catchError((e){
                _setLoading(false);
                print('error deleting room $e');
              });
            })
          ],
          bottom: TabBar(tabs: [
            Tab(child: Text('Sessions')),
            Tab(child: Text('Participants')),
            Tab(child: Text('History')),
          ]),
        ),
        body: _loading 
        ? Center(child: CircularProgressIndicator())
        : TabBarView(
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
    final roomService = Provider.of<RoomService>(context, listen: false);

    return Card(
      child: ListTile(
        // leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text('${session.title}'),
        subtitle: Text('${session.time}'),
        trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
          print('deleting ${session.id}');
          _setLoading(true);
          roomService.deleteHistory(historyElement: session)
          .then((v){
            roomService.getHistory()
            .then((v) {
              _setLoading(false);
            });
          })
          .catchError((e){
            print('error deleting history element $e');
            _setLoading(false);
          });
        }),
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
              children: roomService.participants.length > 0 
              ? roomService.participants.map(
                  (participant) => _buildParticipantTile(context, participant)).toList()
              : _emptyAlert(context, 'No participants have joined your room yet')
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
              children: 
                roomService.sessions.length > 0 
                ? [
                  ...roomService.sessions.map(
                    (session) => _buildSessionTile(context, session)).toList(),
                  CopySessionToken()
                ] : _emptyAlert(context, 'You do not have any polls yet')
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
            child: 
             ListView(
              children: roomService.history.length > 0 
              ? roomService.history.map(
                (session) => _buildHistoryTile(context, session)).toList()
              : _emptyAlert(context, 'No history available')
            ),
            onRefresh: () => roomService.getHistory(),
        );
      },
    );
  }

  List<Widget> _emptyAlert(BuildContext context, String text){
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text(text)),
      ),
      CopySessionToken()
    ];
  }
}

class CopySessionToken extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roomService = Provider.of<RoomService>(context, listen: false);

    return Center(
      child: RaisedButton(
        child: Text('Copy Room Token'),
        onPressed: (){
          Clipboard.setData(ClipboardData(text: roomService.room.id));
          Scaffold.of(context)
            .showSnackBar(SnackBar(
              content: Text('Room Token ${roomService.room.id} copied to clipboard')
            ));
        },
      ),
    );
  }
}