import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:eclicker/services/session_service.dart';
import 'package:eclicker/widgets/results_chart.dart';

class OldResultsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final sessionService = Provider.of<SessionService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: sessionService.getResults(),
        builder: (BuildContext context, AsyncSnapshot<SessionResults> snapshot){
          if(snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

          return ResultsChart(session: snapshot.data);
        },
      )
    );
  }
}