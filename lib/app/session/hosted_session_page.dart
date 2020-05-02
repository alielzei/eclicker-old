import 'package:eclicker/services/session_service.dart';
import 'package:eclicker/widgets/results_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

// needs some code refactoring
class HostedSessionPage extends StatelessWidget {
  // check if session id is valid
  // to be put in a services  
  @override
  Widget build(BuildContext context) {   
    final sessionService = Provider.of<SessionService>(context);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: sessionService.sessionResults(),
        builder: (context, AsyncSnapshot<SessionResults> snapshot){
          if(sessionService.loading 
          || snapshot.connectionState == ConnectionState.waiting
          || snapshot.data == null)
            return Center(child: CircularProgressIndicator());

          return snapshot.data.results != null 
          ? _activeSession(context, snapshot.data)
          : _startButton(context, snapshot.data);
        }
      )
    );
  }

  Widget _startButton(BuildContext context, SessionResults session){
    final sessionService = Provider.of<SessionService>(context, listen: false);
  
      return Column(
        children: <Widget>[
          _sessionDetails(context, session),
          RaisedButton(
            child: Text('Start Poll'),
            onPressed: (){
              sessionService
              .activateSession()
              .catchError((e){
                print('error starting session $e');
              });
            }
          ),
          RaisedButton(
            child: Text('Delete Poll'),
            color: Colors.red,
            onPressed: (){ 
              sessionService
              .deleteSession()
              .then((_){
                Navigator.pop(context);
              })
              .catchError((e){
                print('error deleting session $e');
              });
            }
          )
        ],
      );
  }

  Widget _activeSession(BuildContext context, SessionResults session){
    final sessionService = Provider.of<SessionService>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ResultsChart(session: session),
        RaisedButton(
          color: Colors.red,
          child: Text('Stop Poll'),
          onPressed: () => sessionService.deactivateSession(),
        )
      ],
    );
  }

  Widget _sessionDetails(BuildContext context, SessionResults session){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(session.title, textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
          )),
          ...session.options.map<Widget>((o){
            return Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$o', textAlign: TextAlign.center,),
            ));
          }).toList()
        ]
      ),
    );
  }
}