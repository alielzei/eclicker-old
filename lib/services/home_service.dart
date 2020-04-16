import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@immutable
class Room {
  const Room({
    @required this.id,
    @required this.name
  });
  final String id;
  final String name;
  
  factory Room.fromJson(Map<String, dynamic> json){
    // check validity of fields
    return Room(
      id: json['id'],
      name: json['name']
    );
  }
}

class HomeService extends ChangeNotifier{
  HomeService({@required this.uid}) : assert(uid != null);
  final String uid; 
  
  List<Room> ownedRooms;
  List<Room> joinedRooms;

  Future<List<Room>> getRooms({
    @required String functionName,
  }) async {
    var uri = Uri.https(
      'us-central1-eclicker-1.cloudfunctions.net',
      '/$functionName', {
      'userID': uid
    });
    final response = await http.get(uri);
    
    if(response.statusCode != 200)
      throw Exception('HTTP ERROR: ${response.body}');

    var roomsJson = json.decode(response.body);
    // check if its a list
    // check if the elements are objects 

    return roomsJson.map<Room>(
      (roomJson) => Room.fromJson(roomJson)
    ).toList();
  }

  Future<void> getOwnedRooms() async {
    // handle error here
    ownedRooms = await getRooms(functionName: 'getOwnedRooms');
    notifyListeners();
  }

  Future<void> getJoinedRooms() async {
    joinedRooms = await getRooms(functionName: 'getJoinedRooms');
    notifyListeners();
  }

}