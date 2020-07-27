import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/pages/home.dart';
import 'package:socialdirect_app/Methods/method_auth.dart';
import 'reg_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  final CollectionReference usersRef = Firestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  String email;
  var password;
  bool showSpinner = false;
  bool noError = false;
  bool googleAuth = false;
  String errorMessage;
  User currentUser;
  Future<QuerySnapshot> userData;
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handelSignInAccount(account);
    }, onError: (error) {
      print('Google sign in error : $error');
    });
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then(
          (GoogleSignInAccount account) => handelSignInAccount(account),
        )
        .catchError((err) {
      print('Google sign in silently error : $err');
    });
  }

  getUserData(String query) {
    Future<QuerySnapshot> users =
        usersRef.where("email", isEqualTo: query).getDocuments();
    setState(() {
      userData = users;
    });
    userData.then((value) => value.documents.forEach((doc) {
          currentUser = User.fromDocument(doc);
        }));
  }

  Future googleLogin() async {
    await googleSignIn.signIn();
    Navigator.pushNamed(context, HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    email = value;
                    getUserData(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Input Email !';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Input Password !';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.blue,
                      ),
                    ),
                    hintText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final AuthResult user =
                                await _auth.signInWithEmailAndPassword(
                                    email: email.trim(),
                                    password: password.toString().trim());
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                          currentUser: currentUser,
                                        )),
                              );
                              noError = true;
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (error) {
                            print(error.code);
                            switch (error.code) {
                              case "ERROR_OPERATION_NOT_ALLOWED":
                                errorMessage =
                                    "Anonymous accounts are not enabled";
                                break;
                              case "ERROR_WEAK_PASSWORD":
                                errorMessage = "Your password is too weak";
                                break;
                              case "ERROR_INVALID_EMAIL":
                                errorMessage = "Your email is invalid";
                                break;
                              case "ERROR_EMAIL_ALREADY_IN_USE":
                                errorMessage =
                                    "Email is already in use on different account";
                                break;
                              case "ERROR_INVALID_CREDENTIAL":
                                errorMessage = "Your email is invalid";
                                break;
                              case "ERROR_WRONG_PASSWORD":
                                errorMessage = "Invalid Password";
                                break;

                              case "ERROR_USER_NOT_FOUND":
                                errorMessage = "Your email is invalid";
                                break;
                              default:
                                errorMessage =
                                    "An undefined Error happened, check your email and password";
                            }
                          }
                          setState(() {
                            showSpinner = false;
                          });
                          noError
                              ? Text('')
                              : errorWhileSignUp(errorMessage, context);
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.routeName);
                      },
                      child: Text('Or Register'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await googleLogin();
                  },
                  child: Text('Continue with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handelSignInAccount(GoogleSignInAccount account) {
    if (account != null) {
      print('user signed in ! :$account');
    }
  }
}
