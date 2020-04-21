import 'package:eclicker/app/home/main_drawer.dart';
import 'package:eclicker/app/room/hosted_room_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/room_service.dart';
import 'package:eclicker/services/home_service.dart';

import 'package:eclicker/app/forms/create_room_form.dart';
import 'package:eclicker/app/forms/join_room_form.dart';

class HomePage extends StatelessWidget {
  void _goToRoom(BuildContext context, Room room){
    final homeService = Provider.of<HomeService>(context, listen: false);

    Navigator.push(context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => RoomService(user: homeService.user, room: room),
          child: HostedRoomPage()
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

  Widget _buildRoomTile(BuildContext context, Room room){
    return Card(
      child: ListTile(
        leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(room.name),
        onTap: (){
         _goToRoom(context, room);
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
          children: [
            ...rooms.map(
              (room) => _buildRoomTile(context, room)).toList(),
            button,
          ]
        ),
        onRefresh: () => getRooms(),
    );
  }

  Widget _postListButton(BuildContext context, {
    String title,
    Widget destination
  }){
    return Center(
      child: RaisedButton(
        child: Text(title),
        onPressed: () async {
          final room = await Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => destination
          ));
          if(room != null)
            _goToRoom(context, room);
        }
      ),
    );
  }

  Widget _createButton(BuildContext context){
    return _postListButton(context, 
      title: 'Create Room', 
      destination: CreateRoomForm()
    );
  }

  Widget _buildHostedRooms(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child)
        => _buildRooms(context, 
        getRooms: homeService.getHostedRooms, 
        rooms: homeService.hostedRooms,
        button: child,
      ),
      child: _createButton(context),
    ); 
  }

  Widget _joinButton(BuildContext context){
    return  _postListButton(context, 
      title: 'Join Room', 
      destination: JoinRoomForm()
    );
  }

  Widget _buildJoinedRooms(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child)
        => _buildRooms(context, 
          getRooms: homeService.getJoinedRooms, 
          rooms: homeService.joinedRooms,
          button: child,
        ),
        child: _joinButton(context),
    ); 
  }

}