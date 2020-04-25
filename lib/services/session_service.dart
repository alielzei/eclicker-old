import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

@immutable
class SessionDetails{
  SessionDetails({
    @required this.title,
    @required this.options,
  });

  final String title;
  final List<String> options;

  factory SessionDetails.fromJSON(json){
    return SessionDetails(
      title: json['title'],
      options: List<String>.from(json['options'])
    );
  }

}

@immutable
class SessionResults{
  SessionResults({
    @required this.title,
    @required this.options,
    @required this.results,
  });

  final String title;
  final List<String> options;
  final List<int> results;

  factory SessionResults.fromJSON(json){
    List<int> results = json['results'] != null
    ? List<int>.from(json['results'].values) : null;

    return SessionResults(
      title: json['title'],
      options: List<String>.from(json['options']),
      results: results
    );
  }
}

class SessionService extends ChangeNotifier{
  SessionService({
    @required this.sessionId
  });

  final String sessionId;
  
  SessionDetails sessionDetails;
  bool loading = false;

  void setLoading(bool b){
    loading = b;
    notifyListeners();
  }

  Future<void> getSession() async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/getSession', {
      'session': sessionId
    });
    final response = await http.get(uri);

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    sessionDetails = SessionDetails.fromJSON(
      json.decode(response.body)
    );

    notifyListeners();
  }

  Future<void> submitAnswer({
    @required option
  }) async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/submitAnswer'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'session': sessionId,
        'option': option,
      })
    );

    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');
  } 

  Stream<SessionResults> sessionResults(){
    return Firestore.instance
    .collection('sessions')
    .document(sessionId)
    .snapshots().map((snapshot){
      return SessionResults.fromJSON(snapshot.data);
    });
  }

  Future<void> activateSession() async {
    setLoading(true);
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/activateSession'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'session': sessionId,
      })
    );
    setLoading(false);
    print(response.body);
    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');
    
  }

  Future<void> deactivateSession() async {
    setLoading(true);
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/deactivateSession'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'session': sessionId,
      })
    );
    setLoading(false);
    print(response.body);
    
    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.statusCode}, ${response.body}');
  
  }

  Future<SessionResults> getResults() async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/getResults', {
      'session': sessionId
    });
    final response = await http.get(uri);

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    return SessionResults.fromJSON(json.decode(response.body));
  } 

  Future<void> deleteSession() async {
    setLoading(true);
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/deleteSession'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'session': sessionId,
      })
    );

    if(response.statusCode != 200){
      setLoading(false);
      throw Exception('HTTP ERROR: ${response.body}');
    }
  }
}