import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/post_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:socialdirect_app/pages/profile.dart';

User aboveCurrentUser;

class Feed extends StatefulWidget {
  final User currentUser;
  Feed({this.currentUser});
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final CollectionReference feedRef = Firestore.instance.collection('feed');
  final CollectionReference userRef = Firestore.instance.collection('users');
  Future<User> getCurrentUser() async {
    DocumentSnapshot doc = await userRef.document(widget.currentUser.id).get();
    aboveCurrentUser = User.fromDocument(doc);
    return aboveCurrentUser;
  }

  Future<List<FeedItem>> getActivityFeed() async {
    QuerySnapshot snapshot = await feedRef
        .document(widget.currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<FeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(FeedItem.fromDocument(doc));
    });
    return feedItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data,
          );
        },
        future: getActivityFeed(),
      ),
    ));
  }
}

Widget mediaPreview;
String activityItemText;

class FeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  FeedItem({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory FeedItem.fromDocument(DocumentSnapshot doc) {
    return FeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }
  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: postId,
          userId: userId,
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  ),
                ),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = "liked your post";
    } else if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  ),
                ]),
          ),
          leading: GestureDetector(
            onTap: () => showProfile(context, currentUser: aboveCurrentUser),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfileImg),
            ),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {User currentUser}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(
        currentUser: currentUser,
      ),
    ),
  );
}
