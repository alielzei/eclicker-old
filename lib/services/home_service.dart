import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'auth_service.dart';

@immutable
class Room {
  const Room({
    @required this.id,
    @required this.name
  });
  final String id;
  final String name;
  
  factory Room.fromJson(Map<String, dynamic> json){
    return Room(
      id: json['id'],
      name: json['name']
    );
  }
}

class HomeService extends ChangeNotifier{
  HomeService({@required this.user}) : assert(user != null);
  final User user; 
  String userName;
  
  List<Room> hostedRooms;
  List<Room> joinedRooms;

  Future<List<Room>> getRooms({
    @required String functionName,
  }) async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/$functionName', {
      'user': user.uid
    });
    final response = await http.get(uri);
    
    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');

    var roomsJson = json.decode(response.body);
    // check if its a list

    return roomsJson.map<Room>(
      (roomJson) => Room.fromJson(roomJson)
    ).toList();
  }

  Future<void> getHostedRooms() async {
    // handle error here
    hostedRooms = await getRooms(functionName: 'getHostedRooms');
    notifyListeners();
  }

  Future<void> getJoinedRooms() async {
    joinedRooms = await getRooms(functionName: 'getJoinedRooms');
    notifyListeners();
  }

  Future<Room> createRoom({
    @required String name,
  }) async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/createRoom'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': user.uid,
        'name': name
      })
    );

    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');

    print(json.decode(response.body));
    return Room.fromJson(json.decode(response.body));
  }

  Future<Room> joinRoom({
    @required String token,
  }) async {
    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/joinRoom'
    );

    final response = await http.post(uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': user.uid,
        'token': token
      })
    );

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    return Room.fromJson(json.decode(response.body));
  }

  Future<String> getUserName() async {
    print(user.uid);

    Uri uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/getUser', {
        'user': user.uid
      }
    );
    final response = await http.get(uri);

    if(response.statusCode != 200)
      throw Exception('${response.body}');

    userName = json.decode(response.body)['name'];
    notifyListeners();
  }

}