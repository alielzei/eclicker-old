import 'package:eclicker/services/home_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CreateRoomForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RoomDetailsForm()
    );
  } 
}

class RoomDetailsForm extends StatefulWidget {
  @override
  _RoomDetailsFormState createState() => _RoomDetailsFormState();
}

class _RoomDetailsFormState extends State<RoomDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  @override
  Widget build(BuildContext context) {
    return _loading
    ? Center(child: CircularProgressIndicator())
    : Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _nameTextField(context),
          SizedBox(height: 8,),
          _descriptionTextArea(context),
          _submitButton(context)
        ],
      )
    );
  }

  Widget _nameTextField(BuildContext context){
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Name'
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'You can\'t leave this empty';
        }
        return null;
      },
    );
  }

  Widget _descriptionTextArea(BuildContext context){
    return TextFormField(
      controller: _descController,
      decoration: InputDecoration(
        hintText: 'Description'
      ),
    );
  }

  Widget _submitButton(BuildContext context){
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _setLoading(true);
          final homeService = Provider.of<HomeService>(context, listen: false);
          homeService.createRoom(name: _nameController.text)
          .then((Room room) {
            Navigator.pop(context, room);
          })
          .catchError((error){
            _setLoading(false);
            Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('$error')));
          });
        }
      },
    );

  }
}