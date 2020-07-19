import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleUser {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  GoogleUser({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });
  factory GoogleUser.fromDocument(DocumentSnapshot doc) {
    return GoogleUser(
      id: doc['id'],
      displayName: doc['displayName'],
      username: doc['username'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
    );
  }
}
