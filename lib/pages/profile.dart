import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/home.dart';
import 'edit_profile.dart';

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
  DocumentSnapshot documentSnapshot;

  buildProfileButton() {
    bool isProfileOwner = currentEmail == widget.currentUser.email;
    if (isProfileOwner) {
      return buildOwnerButton();
    }
  }

  Container buildOwnerButton() {
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
        onPressed: () {
          editProfile();
        },
        shape: GFButtonShape.pills,
        text: 'Edit Profile',
        textColor: Colors.black,
        color: GFColors.PRIMARY,
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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: userRef.document(widget.currentUser.id).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User currentUser = User.fromDocument(snapshot.data);
            return SingleChildScrollView(
              child: Column(
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
                                  currentUser.photoUrl),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 55),
                            child: Text(
                              currentUser.username,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 165),
                            child: Text(
                              currentUser.displayName,
                              style: GoogleFonts.nanumMyeongjo(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildOwnerButton(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            '140',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'SHOTS',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 41,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '727',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            'GOALS',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 10,
                        height: 60,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '140M',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            'FOLLOWERS',
                            style: GoogleFonts.nanumMyeongjo(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        currentUser.bio,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.nanumMyeongjo(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Stack(
                      overflow: Overflow.clip,
                      children: <Widget>[
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            child: Container(
                              width: (size.width + 30) * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 13),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  currentUser.photoUrl),
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
                                              padding: const EdgeInsets.only(
                                                  right: 38.0),
                                              child: Text(
                                                currentUser.displayName,
                                                textAlign: TextAlign.left,
                                                style:
                                                    GoogleFonts.nanumMyeongjo(
                                                  color: Colors.black87,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Text('Walid Icon'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 9,
                                    ),
                                    Container(
                                      width: (size.width + 10) * 0.8,
                                      height: (size.height) * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: CachedNetworkImageProvider(
                                              currentUser.photoUrl),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite_border,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('239'),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Icon(
                                          Icons.comment,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('4234'),
                                        Spacer(),
                                        Text('Walid Icon'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text(
                                            currentUser.username,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            currentUser.bio,
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
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
