import 'package:eclicker/services/auth_service.dart';
import 'package:eclicker/services/rooms_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    print('main rebuild');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu), 
            onPressed: (){},
          ),
          title: Text('Home'),
          actions: <Widget>[
            _signOutButton(context),
          ],
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
  
  Widget _signOutButton(BuildContext context){
    return FlatButton(
      child: Text(
        'Logout',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () => _signOut(context),
    );
  }

  Widget _buildOwnedRooms(BuildContext context){
    return Consumer<RoomsService>(
      builder: (context, roomsService, child)
        => _buildRooms(context, roomsService.getOwnedRooms, roomsService.ownedRooms)
    ); 
  }

  Widget _buildJoinedRooms(BuildContext context){
    return Consumer<RoomsService>(
      builder: (context, roomsService, child)
        => _buildRooms(context, roomsService.getJoinedRooms, roomsService.joinedRooms)
    ); 
  }

  Widget _buildRooms(BuildContext context, Function getRooms, List<Room> rooms){
    if(rooms == null){
      getRooms();
      return Center(child: 
        CircularProgressIndicator()
      );
    }

    return RefreshIndicator(
        child: ListView(
          children: rooms.map(
            (room) => _buildRoomTile(room)).toList(),
        ),
        onRefresh: () => getRooms(),
    );
  }

  Widget _buildRoomTile(Room room){
    return Card(
        child: ListTile(
        leading: Icon(CupertinoIcons.group_solid, size: 30,),
        title: Text(room.name)
      ),
    );
  }

}