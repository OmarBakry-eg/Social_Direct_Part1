import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/AuthModel/googleCreateUser.dart';
import 'package:socialdirect_app/pages/profile.dart';
import 'Auth/login_page.dart';
import 'pages/home.dart';
import 'Auth/reg_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        RegisterPage.routeName: (context) => RegisterPage(),
        HomePage.routeName: (c) => HomePage(),
        LoginPage.routeName: (x) => LoginPage(),
        GoogleCreateUser.routeName: (ctx) => GoogleCreateUser(),
        ProfilePage.routeName: (c) => ProfilePage(),
      },
      initialRoute: RegisterPage.routeName,
    );
  }
}
