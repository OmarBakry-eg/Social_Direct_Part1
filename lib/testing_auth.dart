import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialdirect_app/Methods/method_after_auth.dart';
import 'Auth/reg_page.dart';

class TestingAuth extends StatefulWidget {
  static const routeName = '/successful_register';
  final String username;
  TestingAuth({this.username});

  @override
  _TestingAuthState createState() => _TestingAuthState();
}

class _TestingAuthState extends State<TestingAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentLoggedInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        currentLoggedInUser = user;
        print(currentLoggedInUser.email);
      }
    } catch (error) {
      print(error);
    }
  }

  googleLogout() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Your Google/Firebase Username is :${widget.username}'),
              SizedBox(
                height: 15,
              ),
              Text('You are logged in'),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: Text('Logout'),
                onTap: () {
                  _auth.signOut();
                  print('firebase email and password out');
                  youHaveToGetBackToAuthScreen(context);
                },
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: Text('Google Logout'),
                onTap: () {
                  print('google out');
                  googleLogout();
                  youHaveToGetBackToAuthScreen(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
