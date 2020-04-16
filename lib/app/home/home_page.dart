import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:eclicker/services/auth_service.dart';
import 'package:eclicker/services/home_service.dart';

import 'package:eclicker/app/forms/create_room_form.dart';
import 'package:eclicker/app/forms/join_room_form.dart';

import 'package:eclicker/app/room/room_page.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _drawer(context),
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Owned')),
              Tab(child: Text('Joined')),
            ],
          )
        ),
        body: TabBarView(
            children: <Widget>[
              _buildOwnedRooms(context),
              _buildJoinedRooms(context),
            ],
        ),
      ),
    );
  }

  // other file maybe later
  Widget _drawer(BuildContext context){
     return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: Text('John Doe')),
          ListTile(
            title: FlatButton(
              child: Text(
                'Logout',
              ),
              onPressed: () => _signOut(context),
            )
          )
        ],
      ),
    );
  }

  Widget _postListButton(BuildContext context, {
    String title,
    Widget destination
  }){
    return Center(
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(title, style: TextStyle(
          color: Colors.white,
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => destination
          ));
        }
      ),
    );
  }

  Widget _buildOwnedRooms(BuildContext context){
    return Consumer<HomeService>(
      builder: (context, homeService, child)
        => _buildRooms(context, 
        getRooms: homeService.getOwnedRooms, 
        rooms: homeService.ownedRooms,
        button: child,
      ),
      child: _postListButton(context, 
        title: 'Create Room', 
        destination: CreateRoomForm()
      )
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
        child: _postListButton(context, 
          title: 'Join Room', 
          destination: JoinRoomForm()
        )
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

  Widget _buildRoomTile(BuildContext context, Room room){
    return Card(
      child: ListTile(
        leading: Icon(CupertinoIcons.group_solid, size: 30),
        title: Text(room.name),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => RoomPage(roomID: room.id)
          ));
        },
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }

}