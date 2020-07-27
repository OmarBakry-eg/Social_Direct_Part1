import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialdirect_app/Methods/cached_images.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/comments.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String mediaUrl;
  final String description;
  final dynamic likes;
  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.mediaUrl,
    this.description,
    this.likes,
  });
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      mediaUrl: doc['mediaUrl'],
      description: doc['description'],
      likes: doc['likes'],
    );
  }
  int getLikeCount(Map likes) {
    if (likes == null) {
      return 0;
    }
    int conut = 0;
    likes.values.forEach((val) {
      if (val == true) {
        conut += 1;
      }
    });
    return conut;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        mediaUrl: this.mediaUrl,
        description: this.description,
        likes: this.likes,
        likeCount: getLikeCount(likes),
      );
}

class _PostState extends State<Post> {
  User currentUser;
  final String postId;
  final String ownerId;
  final String username;
  final String mediaUrl;
  final String description;
  Map likes;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.mediaUrl,
    this.description,
    this.likes,
    this.likeCount,
  });
  final CollectionReference userRef = Firestore.instance.collection('users');
  final CollectionReference postRef = Firestore.instance.collection('posts');
  final CollectionReference feedRef = Firestore.instance.collection('feed');
  handleLikePost() {
    bool _isLiked = likes[ownerId] == true;
    if (_isLiked) {
      postRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({
        'likes.$ownerId ': false,
      });
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[ownerId] = false;
      });
    } else if (!_isLiked) {
      postRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({
        'likes.$ownerId ': true,
      });
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[ownerId] = true;
        showHeart = true;
      });
      Timer(Duration(microseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivityFeed() {
    //  bool isNotPostOwner = currentUser.id != widget.ownerId;
    //if(isNotPostOwner){
    feedRef
        .document(widget.ownerId)
        .collection('feedItems')
        .document(widget.postId)
        .setData({
      'mediaUrl': mediaUrl,
      'postId': postId,
      'timestamp': Timestamp.now(),
      'type': 'like',
      'userId': currentUser.id,
      'userProfileImg': currentUser.photoUrl,
      ' username': currentUser.username,
    });
    // }
  }

  removeLikeFromActivityFeed() {
//    bool isNotPostOwner = currentUser.id != widget.ownerId;
//    if(isNotPostOwner){
    feedRef
        .document(widget.ownerId)
        .collection('feedItems')
        .document(widget.postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[ownerId] == true);
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: userRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        currentUser = User.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                Align(
                  child: Container(
                    width: (size.width + 30) * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                currentUser.photoUrl,
                              ),
                              radius: 25,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  currentUser.username,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.breeSerif(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 38.0),
                                  child: Text(
                                    currentUser.displayName,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.nanumMyeongjo(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.more_vert),
                          ],
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        buildPost(size),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Wrap(
                            children: <Widget>[
                              Text(
                                username,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                description,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildPost(Size size) {
    return Column(
      children: <Widget>[
        Container(
          width: (size.width + 10) * 0.8,
          height: (size.height) * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: cachedNetworkImage(mediaUrl),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: <Widget>[
            IconButton(
              onPressed: handleLikePost,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink,
                size: 40,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text('$likeCount likes'),
            SizedBox(
              width: 14,
            ),
            IconButton(
              icon: Icon(
                Icons.comment,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllComments(
                              currentUser: currentUser,
                              postId: postId,
                              postMediaUrl: mediaUrl,
                              postOwnerId: ownerId,
                            )));
              },
            ),
            SizedBox(
              width: 4,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('comments')
                    .document(widget.postId)
                    .collection('comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('0 comments');
                  }
                  var commentsCount = snapshot.data.documents.length;
                  return Text('$commentsCount comments');
                }),
            Spacer(),
            Icon(Icons.more_vert),
          ],
        ),
      ],
    );
  }
}
