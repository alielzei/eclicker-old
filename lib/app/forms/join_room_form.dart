import 'package:eclicker/services/home_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class JoinRoomForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TokenJoinForm()
    );
  } 
}

class TokenJoinForm extends StatefulWidget {
  @override
  _TokenJoinFormState createState() => _TokenJoinFormState();
}

class _TokenJoinFormState extends State<TokenJoinForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _tokenController = TextEditingController();

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
          _tokenTextField(context),
          _submitButton(context)
        ],
      )
    );
  }

  Widget _tokenTextField(BuildContext context){
    return TextFormField(
      controller: _tokenController,
      decoration: InputDecoration(
        hintText: 'Token'
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'You can\'t leave this empty';
        }
        return null;
      },
    );
  }

  Widget _submitButton(BuildContext context){
    return RaisedButton(
      child: Text('Submit'),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _setLoading(true);
          final homeService = Provider.of<HomeService>(context, listen: false);
          homeService.joinRoom(token: _tokenController.text)
          .then((Room room) {
            Navigator.pop(context, room);
          })
          .catchError((error){
            _setLoading(false);
            Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('${error}')));
          });
        }
      },
    );

  }
}