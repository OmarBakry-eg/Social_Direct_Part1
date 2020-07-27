import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/widgets/comment.dart';

class AllComments extends StatefulWidget {
  final User currentUser;
  final String postId;
  final String postMediaUrl;
  final String postOwnerId;
  AllComments(
      {this.currentUser, this.postId, this.postMediaUrl, this.postOwnerId});
  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  TextEditingController commentsController = TextEditingController();
  final CollectionReference feedRef = Firestore.instance.collection('feed');

  Widget buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('comments')
          .document(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Comment> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    Firestore.instance
        .collection('comments')
        .document(widget.postId)
        .collection('comments')
        .add({
      'username': widget.currentUser.username,
      'comment': commentsController.text,
      'timestamp': Timestamp.now(),
      'photoUrl': widget.currentUser.photoUrl,
      'userId': widget.currentUser.id,
    });
    commentInActivityFeed();
    commentsController.clear();
  }

  commentInActivityFeed() {
    //   bool isNotPostOwner = widget.currentUser.id != widget.postOwnerId;
    // if(isNotPostOwner){
    feedRef.document(widget.postOwnerId).collection('feedItems').add({
      'mediaUrl': widget.postOwnerId,
      'postId': widget.postId,
      'timestamp': Timestamp.now(),
      'type': 'comment',
      'commentData': commentsController.text,
      'userId': widget.currentUser.id,
      'userProfileImg': widget.currentUser.photoUrl,
      ' username': widget.currentUser.username,
    });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildComments(),
            ),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: commentsController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: 'Type your Comment...',
                  border: InputBorder.none,
                ),
              ),
              trailing: FlatButton(
                onPressed: addComment,
                child: Text('post'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
