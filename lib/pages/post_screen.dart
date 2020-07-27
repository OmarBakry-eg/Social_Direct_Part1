import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/widgets/posts.dart';

final CollectionReference postReference =
    Firestore.instance.collection('posts');

class PostScreen extends StatelessWidget {
  final String userId, postId;
  PostScreen({this.postId, this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Post post = Post.fromDocument(snapshot.data);
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
          ),
          body: ListView(
            children: <Widget>[
              Container(
                child: post,
              ),
            ],
          ),
        ));
      },
      future: postReference
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .get(),
    );
  }
}
