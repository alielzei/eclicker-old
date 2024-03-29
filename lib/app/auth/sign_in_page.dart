import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eclicker/services/auth_service.dart';

class SignInPage extends StatefulWidget {

  SignInPage({ this.toggleView });
  final Function toggleView;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwController = TextEditingController();

  String _error = '';

  bool _newView = true;
  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  Future<void> _signIn(context, {
    @required String email, 
    @required String password
  }) async {
    _setLoading(true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signIn(email: email, password: password);
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = 'Could not sign in with those credentials';
      });
    }
    _setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Sign in'),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              widget.toggleView();
            },
            child: Text('Sign Up',
              style: TextStyle(
                color: Colors.white
              )
            ),
          )
        ],
      ),
      body: _loading
      ? Center(child: CircularProgressIndicator())
      : _buildBody(context)
    );
  }

  Widget _buildLogo(){
    return GestureDetector(
      onLongPress: () => setState(() => _newView = !_newView),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo_with_text.png'),
            fit: BoxFit.contain,
          ),
        ),
        height : 300,
        width: 300,
      ),
    );
  }

  Widget _buildBody(BuildContext context){
    return _newView ? _newBody(context) : _oldBody(context);
  }

  Widget _oldBody(BuildContext context){
    return ListView(
        children: <Widget>[
          _buildLogo(),
          RaisedButton(
            child: Text('Host', style: TextStyle(fontSize: 20)),
            onPressed: () => _signIn(context,
              email: 'bdeir@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Ali',style: TextStyle(fontSize: 20)),
            onPressed: () => _signIn(context,
              email: 'ali@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Nariman',style: TextStyle(fontSize: 20)),
            onPressed: () => _signIn(context,
              email: 'nariman@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Nadine',style: TextStyle(fontSize: 20)),
            onPressed: () => _signIn(context,
              email: 'nadine@eclicker.com',
              password: '123456'
            ),
          ),
          RaisedButton(
            child: Text('Hussein',style: TextStyle(fontSize: 20)),
            onPressed: () => _signIn(context,
              email: 'hussein@eclicker.com',
              password: '123456'
            ),
          ),
        ],
      );
  }
  
  Widget _newBody(BuildContext context){
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildLogo(),
          _emailField(),
          SizedBox(height: 12.0),
          _passwordField(),
          _signInButton(),
          SizedBox(height: 20.0),
          _errorText()
        ],
      ),
    );
  }

  Widget _emailField(){
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email'
      ),
      validator: (val) => val.isEmpty ? 'Enter an email' : null,
    );
  }

  Widget _passwordField(){
    return TextFormField(
      controller: passwController,
      decoration: InputDecoration(
        hintText: 'Password'
      ),
      validator: (val) => val.length < 6 ? 'Enter a password that contains 6+ characters' : null,
      obscureText: true,
    );
  }

  Widget _signInButton(){
    return RaisedButton(
      child: Text('Sign In'),
      onPressed: () {
        if(_formKey.currentState.validate())
          _signIn(context, 
            email: emailController.text,
            password: passwController.text
          );
      }
    );
  }
  
  Widget _errorText(){
    return Center(
      child: Text(
        _error,
        style: TextStyle(
          color: Colors.red,
          fontSize: 14.0,
        ),
      ),
    );
  }

}
