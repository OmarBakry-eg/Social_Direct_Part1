import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<void> errorWhileSignUp(errorMessage, BuildContext context) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Error While Registering'),
            content: Text(errorMessage.toString()),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Try Again',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ));
}
