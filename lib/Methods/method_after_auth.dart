import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialdirect_app/Auth/reg_page.dart';

Future<void> youHaveToGetBackToAuthScreen(BuildContext context) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('You\'re logging out'),
      content: Text('We will Returning you back to auth screen'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterPage.routeName);
          },
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    ),
  );
}
