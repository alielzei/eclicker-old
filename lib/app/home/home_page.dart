import 'package:eclicker/app/home/main_drawer.dart';
import 'package:eclicker/app/room/hosted_room_page.dart';
import 'package:eclicker/app/room/joined_room_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/room_service.dart';
import 'package:eclicker/services/home_service.dart';

import 'package:eclicker/app/forms/create_room_form.dart';
import 'package:eclicker/app/forms/join_room_form.dart';

class HomePage extends StatelessWidget {
  void _goToRoom(BuildContext context, {
    Room room, 
    Widget destination
  }){
    final homeService = Provider.of<HomeService>(context, listen: false);

    Navigator.push(context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => RoomService(user: homeService.user, room: room),
          child: destination
        )
      )
    );
  } 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Hosted')),
              Tab(child: Text('Joined')),
            ],
          )
        ),
        body: TabBarView(
            children: <Widget>[
              _buildHostedRooms(context),
              _buildJoinedRooms(context),
            ],
        ),
      ),
    );
  }

  Widget _buildRoomTile(BuildContext context, {
    Room room, 
    Widget destination,
  }){
    return Card(
      child: ListTile(
        leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(room.name),
        onTap: (){
         _goToRoom(context, room: room, destination: destination);
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  Widget _buildRooms(BuildContext context, {
    @required Function getRooms, 
    @required List<Room> rooms,
    @required Widget button,
    @required Widget destination,
    @required String noRoomsText
  }){
    if(rooms == null){
      // this may throw error
      getRooms();
      return Center(
        child: CircularProgressIndicator()
      );
    }

    return RefreshIndicator(
        child: ListView(
          children: 
          rooms.length > 0 ? [
            ...rooms.map(
              (room) => _buildRoomTile(context, room: room, destination: destination)).toList(),
            button,
          ]
          : [
            _emptyAlert(context, noRoomsText),
            button
          ]
        ),
        onRefresh: () => getRooms(),
    );
  }

  Widget _postListButton(BuildContext context, {
    String title,
    Widget buttonDestination,
    Widget formDestination
  }){
    return Center(
      child: RaisedButton(
        child: Text(title),
        onPressed: () async {
          final room = await Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => buttonDestination
          ));
          if(room != null)
            _goToRoom(context, room: room, destination: formDestination);
        }
      ),
    );
  }

  Widget _createButton(BuildContext context){
    return _postListButton(context, 
      title: 'Create Room', 
      buttonDestination: CreateRoomForm(),
      formDestination: HostedRoomPage()
    );
  }

  Widget _buildHostedRooms(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child)
        => _buildRooms(context, 
        getRooms: homeService.getHostedRooms, 
        rooms: homeService.hostedRooms,
        button: child,
        destination: HostedRoomPage(),
        noRoomsText: 'You do not have any hosted rooms'
      ),
      child: _createButton(context),
    ); 
  }

  Widget _joinButton(BuildContext context){
    return  _postListButton(context, 
      title: 'Join Room', 
      buttonDestination: JoinRoomForm(),
      formDestination: JoinedRoomPage()
    );
  }

  Widget _buildJoinedRooms(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child)
        => _buildRooms(context, 
          getRooms: homeService.getJoinedRooms, 
          rooms: homeService.joinedRooms,
          button: child,
          destination: JoinedRoomPage(),
          noRoomsText: 'You do not have any joined rooms'
        ),
        child: _joinButton(context),
    ); 
  }

  Widget _emptyAlert(BuildContext context, String text){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(child: Text(text)),
    );
  }

}