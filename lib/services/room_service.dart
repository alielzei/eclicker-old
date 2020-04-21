import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth_service.dart';
import 'home_service.dart';

@immutable
class Session {
  const Session({
    @required this.id,
    @required this.title
  });
  final String id;
  final String title;
  
  factory Session.fromJson(Map<String, dynamic> json){
    return Session(
      id: json['id'],
      title: json['title']
    );
  }
}

class RoomService extends ChangeNotifier{
  RoomService({
    @required this.user,
    @required this.room,
  }) : assert(user != null);

  final User user;
  final Room room;

  bool _mounted = true;

  List<Session> sessions;
  List<String> participants;

  @override
  void dispose(){
    _mounted = false;
    super.dispose();
  }

  Future<void> getSessions() async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/getSessions', {
      'room': room.id
    });
    final response = await http.get(uri);

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    var sessionsJson = json.decode(response.body);
    sessions = sessionsJson.map<Session>(
      (roomJson) => Session.fromJson(roomJson)
    ).toList();

    if(_mounted) notifyListeners();
  }
  
  Future<void> getParticipants() async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/getParticipants', {
      'room': room.id
    });
    final response = await http.get(uri);

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    var participantsJson = json.decode(response.body);
    participants = List<String>.from(participantsJson);

    if(_mounted) notifyListeners();
  }

  Future<void> createSession({
    @required String title,
    @required List<String> options,
  }) async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/createSession'
    );
    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'room': room.id,
        'title': title,
        'options': options
      })
    );

    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');
  }

}