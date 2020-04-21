import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclicker/services/room_service.dart';
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

class HostedSessionPage extends StatelessWidget {

  // check if session id is valid
  // to be put in a service
  Stream<List<int>> sessionResults(String sessionID){
    return Firestore.instance
    .collection('sessions')
    .document(sessionID)
    .snapshots().map((snapshot)
      => List<int>.from(snapshot.data['results'].values));
  }
  
  Widget _resultsChart(List<String> options, List<int> results){
    var data = List<OptionSubmits>.generate(options.length, 
      (i) => OptionSubmits(
        options[i], 
        results[i], 
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
    
    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    return new Padding(
      padding: EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      )
    );
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: sessionResults('JpykRQvvsYq9aUQqStAe'),
        builder: (context, snapshot){
          return _resultsChart(['A', 'B', 'C'], snapshot.data);
        }
      )
    );
  }
}