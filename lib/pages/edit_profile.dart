import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CollectionReference usersRef = Firestore.instance.collection('users');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  User user;
  TextEditingController bioEditing = TextEditingController();
  TextEditingController displayNameEditing = TextEditingController();
  bool isUpdated = false;
  Timer timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder(
          future: usersRef.document(widget.currentUserId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            user = User.fromDocument(snapshot.data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                isUpdated
                    ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.purple),
                      )
                    : Text(''),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  radius: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: displayNameEditing,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Input email !';
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
                    hintText: 'DisplayName',
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: bioEditing,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Input email !';
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
                    hintText: 'Bio',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  onPressed: handleSubmit,
                  child: Text('Submit'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  handleSubmit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isUpdated = true;
      });
      await usersRef.document(widget.currentUserId).updateData({
        "displayName": displayNameEditing.text,
        "bio": bioEditing.text,
      });
      DocumentSnapshot doc =
          await usersRef.document(widget.currentUserId).get();
      setState(() {
        user = User.fromDocument(doc);
      });

      SnackBar snackBar = SnackBar(
        content: Text('Profile Updated'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    timer = Timer(Duration(seconds: 2), () {
      Navigator.pop(context, this.user.id);
      timer.cancel();
      setState(() {
        isUpdated = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
}
