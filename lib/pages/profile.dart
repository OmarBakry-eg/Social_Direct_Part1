import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialdirect_app/Methods/vertical_divider.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/home.dart';
import 'package:socialdirect_app/widgets/posts.dart';
import 'package:socialdirect_app/widgets/profile_info.dart';
import 'edit_profile.dart';

final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  final User currentUser;
  ProfilePage({this.currentUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentEmail = currentLoggedInUser?.email;
  final CollectionReference userRef = Firestore.instance.collection('users');
  final CollectionReference postRef = Firestore.instance.collection('posts');
  final CollectionReference feedRef = Firestore.instance.collection('feed');
  DocumentSnapshot documentSnapshot;
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];
  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .document(widget.currentUser.id)
        .collection('userFollowers')
        .document(homeCurrentUser.id)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .document(widget.currentUser.id)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(widget.currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = homeCurrentUser.id == widget.currentUser.id;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: editProfile,
      );
    } else if (isFollowing) {
      return buildButton(
        text: "UnFollow",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        function: handleFollowUser,
      );
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove follower
    followersRef
        .document(widget.currentUser.id)
        .collection('userFollowers')
        .document(homeCurrentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .document(homeCurrentUser.id)
        .collection('userFollowing')
        .document(widget.currentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete activity feed item for them
    feedRef
        .document(widget.currentUser.id)
        .collection('feedItems')
        .document(homeCurrentUser.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .document(widget.currentUser.id)
        .collection('userFollowers')
        .document(homeCurrentUser.id)
        .setData({});
    // Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .document(homeCurrentUser.id)
        .collection('userFollowing')
        .document(widget.currentUser.id)
        .setData({});
    // add activity feed item for that user to notify about new follower (us)
    feedRef
        .document(widget.currentUser.id)
        .collection('feedItems')
        .document(homeCurrentUser.id)
        .setData({
      "type": "follow",
      "ownerId": widget.currentUser.id,
      "username": homeCurrentUser.username,
      "userId": homeCurrentUser.id,
      "userProfileImg": homeCurrentUser.photoUrl,
      "timestamp": Timestamp.now(),
    });
  }

  Container buildButton({String text, Function function}) {
    return Container(
      width: 100,
      height: 38,
      child: GFButton(
        boxShadow: BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          spreadRadius: 1,
          offset: Offset(0, 6),
        ),
        onPressed: function,
        shape: GFButtonShape.pills,
        text: text,
        textColor: Colors.black,
        color: isFollowing ? GFColors.SUCCESS : GFColors.DANGER,
        type: GFButtonType.outline2x,
        size: GFSize.LARGE,
      ),
    );
  }

  editProfile() async {
    var newUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: widget.currentUser.id),
      ),
    );
    documentSnapshot = await userRef.document(newUpdate).get();
    setState(() {
      newUpdate = widget.currentUser.id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: userRef.document(widget.currentUser.id).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User currentUser = User.fromDocument(snapshot.data);
            return ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: (size.height - 50) * 0.5,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 3,
                            offset: Offset(0, 6),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(45),
                          bottomLeft: Radius.circular(45),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(45),
                              bottomLeft: Radius.circular(45),
                            ),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Image(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                  currentUser.photoUrl,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                currentUser.username,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentUser.displayName,
                                style: GoogleFonts.nanumMyeongjo(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                        ),
                        buildProfileButton(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ProfileInformation(
                            description: 'SHOTS', number: postCount.toString()),
                        verticalDivider(),
                        ProfileInformation(
                            description: 'FOLLOWING',
                            number: followingCount.toString()),
                        verticalDivider(),
                        ProfileInformation(
                          description: 'FOLLOWERS',
                          number: followerCount.toString(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        currentUser.bio,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    buildProfilePosts()
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buildProfilePosts() {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (posts.isEmpty) {
      return Center(
        child: Text('NOoOo Posts Yet !!!'),
      );
    } else {
      return Column(
        children: posts,
      );
    }
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef
        .document(widget.currentUser.id)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((e) => Post.fromDocument(e)).toList();
    });
  }
}
