import 'package:flutter/material.dart';

class GoogleCreateUser extends StatefulWidget {
  static const routeName = '/google_create_user';
  @override
  _GoogleCreateUserState createState() => _GoogleCreateUserState();
}

class _GoogleCreateUserState extends State<GoogleCreateUser> {
  var _formKey = GlobalKey<FormState>();
  String username;
  submit() {
    _formKey.currentState.save();
    Navigator.pop(context, username);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                onSaved: (value) {
                  username = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Input username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'Must be at least 3 characters',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                onPressed: submit,
                child: Text('Submit'),
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
