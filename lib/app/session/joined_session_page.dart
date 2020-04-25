import 'package:eclicker/services/home_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eclicker/services/session_service.dart';

class JoinedSessionPage extends StatefulWidget {
  @override
  _JoinedSessionPageState createState() => _JoinedSessionPageState();
}

class _JoinedSessionPageState extends State<JoinedSessionPage> {

  int selectedOption;

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  void _submitAnswer(){
    final sessionService = Provider.of<SessionService>(context, listen: false);

    _setLoading(true);
    sessionService.submitAnswer(option: selectedOption)
    .then((v){
      _setLoading(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Your answer was submitted'))
        )
      ));
    })
    .catchError((e){
      print(e);
    });
  }
  
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(),
      body: _loading 
      ? Center(child: CircularProgressIndicator())
      : _buildSession(context)
    );
  }

  Widget _buildSession(BuildContext context){
    return Consumer<SessionService>(
      builder: (context, sessionService, child){
        SessionDetails session = sessionService.sessionDetails;

        if(session == null){
          sessionService.getSession();
          return Center(child: CircularProgressIndicator());
        }

        if(!session.free){
          return Center(child: Text('You already answered'));
        }

        return ListView(
          children: <Widget>[
            _buildQuestion(context, session.title),
            ..._buildOptions(context, session.options),
            _submitButton(context)
          ].where((o) => o != null).toList()
        );
    });
  }

  Widget _buildQuestion(BuildContext context, String title){
    return Text(title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      )
    );
  }

  List _buildOptions(BuildContext context, List<String> options){
    return List<Widget>.generate(options.length,
      (i) => _buildOption(context, i, options[i]));
  }

  Widget _buildOption(BuildContext context, int index, String option){
    return RaisedButton(
      color: selectedOption == index
      ? Theme.of(context).primaryColorLight
      : Theme.of(context).buttonColor,
      onPressed: (){
        setState((){
          selectedOption = index;
        });
      },
      child: Text(option),
    );
  }

  Widget _submitButton(BuildContext context){
    return selectedOption != null ? 
    RaisedButton(
      onPressed: () => _submitAnswer(),
      child: Text('Submit', style: TextStyle(
        fontWeight: FontWeight.bold,
      )),
    ) : null;
      // SessionTimer(),
  }

}