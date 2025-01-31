import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialdirect_app/Methods/method_after_auth.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/addpost.dart';
import 'package:socialdirect_app/pages/chat_screen.dart';
import 'package:socialdirect_app/pages/profile.dart';
import 'package:socialdirect_app/pages/search.dart';
import 'package:socialdirect_app/pages/shopping.dart';
import 'package:socialdirect_app/pages/timeline.dart';
import '../Auth/reg_page.dart';
import 'feed.dart';

FirebaseUser currentLoggedInUser;
User homeCurrentUser;

class HomePage extends StatefulWidget {
  static const routeName = '/successful_Auth';
  final User currentUser;
  HomePage({this.currentUser});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userRef = Firestore.instance.collection('users');
  PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
    getCurrentUser();
    getCurrentUserTwo();
  }

  Future<User> getCurrentUserTwo() async {
    DocumentSnapshot doc = await userRef.document(widget.currentUser.id).get();
    homeCurrentUser = User.fromDocument(doc);
    return homeCurrentUser;
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          currentLoggedInUser = user;
          print('this is signed in email : ${currentLoggedInUser.email}');
        });
      } else {
        print(
            'this is signed in googleEmail : ${googleSignIn.currentUser.email}');
      }
    } catch (error) {
      print(error);
    }
  }

  googleLogout() {
    googleSignIn.signOut();
  }

  handelLogout() {
    googleLogout();
    _auth.signOut();
    print('firebase and google out');
    youHaveToGetBackToAuthScreen(context);
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTapFunction(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(microseconds: 300), curve: Curves.easeInOutBack);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: RaisedButton(
            onPressed: handelLogout,
            child: Text('Logout'),
          ),
          leading: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              }),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Timeline(
              currentUser: widget.currentUser,
            ),
            Shopping(),
            AddPost(
              currentUser: widget.currentUser,
            ),
            ChatScreen(
              currentUser: widget.currentUser,
            ),
            Feed(
              currentUser: widget.currentUser,
            ),
            ProfilePage(
              currentUser: widget.currentUser,
            ),
          ],
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.whatshot,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_a_photo,
                size: 35,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_active,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
            ),
          ],
          activeColor: Colors.orange,
          currentIndex: pageIndex,
          onTap: onTapFunction,
        ),
      ),
    );
  }
}
