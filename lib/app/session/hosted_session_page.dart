import 'package:eclicker/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class OptionSubmits{
  final String option;
  final int submits;  
  final charts.Color color;

  OptionSubmits(this.option, this.submits, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
    );
}

// needs some code refactoring
class HostedSessionPage extends StatelessWidget {
  // check if session id is valid
  // to be put in a services  
  Widget _resultsChart(SessionResults session){
      var data = List<OptionSubmits>.generate(session.options.length, 
        (i) => OptionSubmits(
          session.options[i], 
          session.results[i], 
          Colors.red
        )
      ).toList();

      var series = [
        new charts.Series(
          id: 'submits',
          domainFn: (OptionSubmits submits, _) => submits.option,
          measureFn: (OptionSubmits submits, _) => submits.submits,
          colorFn: (OptionSubmits submits, _) => submits.color,
          data: data,
        )
      ];
      
      return Center(
        child: new SizedBox(
          height: 300.0,
          child:  charts.BarChart(
            series,
            animate: true,
          )
        ),
      );
    }

  @override
  Widget build(BuildContext context) {   
    final sessionService = Provider.of<SessionService>(context);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: sessionService.sessionResults(),
        builder: (context, snapshot){
          if(sessionService.loading || snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          return snapshot.hasData 
          ? _activeSession(context, snapshot.data)
          : _startButton(context);
        }
      )
    );
  }

  Widget _startButton(BuildContext context){
    final sessionService = Provider.of<SessionService>(context, listen: false);
    
    return Center(
      child: RaisedButton(
        child: Text('Start Session'),
        onPressed: (){
          sessionService.activateSession();
        }
      ),
    );
  }

  Widget _activeSession(BuildContext context, SessionResults session){
    final sessionService = Provider.of<SessionService>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(session.title, style: Theme.of(context).textTheme.title),
        _resultsChart(session),
        RaisedButton(
          child: Text('Stop Session'),
          onPressed: () => sessionService.deactivateSession(),
        )
      ],
    );
  }
}