import 'package:eclicker/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OptionSubmits{
  final String option;
  final int submits;  
  final charts.Color color;

  OptionSubmits(this.option, this.submits, Color color)
    : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha
    );
}

class ResultsChart extends StatelessWidget {

  ResultsChart({ @required this.session });
  final SessionResults session;

  @override
  Widget build(BuildContext context) {
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
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(session.title, style: Theme.of(context).textTheme.title),
        Center(
          child: SizedBox(
            height: 300.0,
            child:  charts.BarChart(
              series,
              animate: true,
            )
          ),
        ),
      ],
    );
  }
}