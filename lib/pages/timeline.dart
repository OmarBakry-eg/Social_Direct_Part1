import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';

class Timeline extends StatefulWidget {
  final String currentUserId;
  Timeline({this.currentUserId});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final CollectionReference usersRef = Firestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: usersRef.document(widget.currentUserId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          User user = User.fromDocument(snapshot.data);
          return Center(
            child: Text('This is user display name : ${user.displayName}'),
          );
        },
      ),
    );
  }
}
