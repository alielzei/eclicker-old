import 'package:eclicker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  
  SignUpPage({ this.toggleView });
  final Function toggleView;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  final _formKey = GlobalKey<FormState>();

  final firstController = TextEditingController();
  final lastnController = TextEditingController();
  final emailController = TextEditingController();
  final passwController = TextEditingController();

  String _error = '';

  bool _loading = false;
  void _setLoading(bool b) => setState(() => _loading = b);

  Future<void> _signUp(context, {
    @required String first,
    @required String last,
    @required String email, 
    @required String password
  }) async {
    _setLoading(true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.signUp(first: first, last: last, email: email, password: password);
    } catch (e) {
      print(e.toString());
      setState(() {
        _error = 'Could not sign up with those credentials';
      });
    }
    _setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Sign Up'),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              widget.toggleView();
            },
            child: Text('Sign In',
              style: TextStyle(
                color: Colors.white
              )
            ),
          )
        ],
      ),
      body: _loading
      ? Center(child: CircularProgressIndicator())
      : Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildLogo(),
            _nameFields(),
            SizedBox(height: 12.0),
            _emailField(),
            SizedBox(height: 12.0),
            _passwordField(),
            _signUpButton(),
            SizedBox(height: 20.0),
            _errorText()
          ],
        ),
      )
    );
  }

  Widget _buildLogo(){
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo_with_text.png'),
          fit: BoxFit.contain,
        ),
      ),
      height : 300,
      width: 300,
    );
  }

  Widget _nameFields(){
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: firstController,
            decoration: InputDecoration(
              hintText: 'First Name'
            ),
            validator: (val) => val.isEmpty ? 'This cannot be empty' : null,
          )
        ),
        SizedBox(width: 12.0,),
        Expanded(
          child: TextFormField(
            controller: lastnController,
            decoration: InputDecoration(
              hintText: 'Last Name'
            ),
            validator: (val) => val.isEmpty ? 'This cannot be empty' : null,
          )
        ),
      ],
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
    );
  }

  Widget _signUpButton(){
    return RaisedButton(
      child: Text('Sign Up'),
      onPressed: () {
        if(_formKey.currentState.validate())
          _signUp(context, 
            first: firstController.text,
            last: lastnController.text,
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