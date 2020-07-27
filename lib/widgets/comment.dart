import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String photoUrl;
  final String comment;
  final Timestamp timestamp;
  Comment({
    this.timestamp,
    this.username,
    this.userId,
    this.photoUrl,
    this.comment,
  });
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      photoUrl: doc['photoUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            comment,
          ),
          trailing: Text(username),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(photoUrl),
          ),
          subtitle: Text(timeAgo.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
