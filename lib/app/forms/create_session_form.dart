import 'package:flutter/material.dart';

class CreateSessionForm extends StatefulWidget {

  const CreateSessionForm ({ Key key, this.submitSession }): super(key: key);
  final Function submitSession;

  @override
  _CreateSessionFormState createState() => _CreateSessionFormState();
}

class _CreateSessionFormState extends State<CreateSessionForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  List<TextEditingController> _optionsTextControllers = [];

  int _fieldCounter = 0;

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loading
      ? Center(child: CircularProgressIndicator())
      : Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _titleField(),
            ...List<Widget>.generate(
              _optionsTextControllers.length, 
              (idx) => _optionField(idx)
            ),
            _addOptionButton(),
            _submitButton()
          ],
        )
      ),
    );
  }

  Widget _titleField(){
    return TextFormField(
      validator: (value) 
        => value.isEmpty ? 'You can\'t leave this empty' : null,
      controller: _titleController,
      decoration: InputDecoration(
        hintText: "Title"
      ),
    );
  }

  Widget _optionField(int idx){
    return Dismissible(
      onDismissed: (DismissDirection direction){
        setState((){
          _optionsTextControllers.removeAt(idx);
        });
      },
      key: ValueKey(_fieldCounter++),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: TextFormField(
          validator: (value) 
            => value.isEmpty ? 'You can\'t leave this empty' : null,
          controller: _optionsTextControllers[idx],
          decoration: InputDecoration(
            hintText: "Option ${idx+1}"
          ),
        ),
      ),
    );
  }

  Widget _addOptionButton(){
    return Center(
      child: RaisedButton(child: Text('Add Choice'), onPressed: (){
        setState((){
          _optionsTextControllers.add(new TextEditingController());
        });
      }),
    );
  }

  Widget _submitButton(){
    return Center(
      child: RaisedButton(child: Text('Submit'), onPressed: (){
        if (_formKey.currentState.validate()) {
          _setLoading(true);
          widget.submitSession(
            title: _titleController.text,
            options: _optionsTextControllers.map((c) => c.text).toList()
          )
          .then((_){
            _setLoading(false);
            Navigator.pop(context);
          })
          .catchError((error){
            _setLoading(false);
            Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('$error')));
          });
        }
      }),
    );
  }
}