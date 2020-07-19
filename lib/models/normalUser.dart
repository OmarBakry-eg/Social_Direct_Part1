import 'package:cloud_firestore/cloud_firestore.dart';

class NormalUser {
  final String id;
  final String displayName;
  final String bio;
  final String username;
  final String photoUrl;
  final String email;
  NormalUser({
    this.id,
    this.displayName,
    this.bio,
    this.username,
    this.photoUrl,
    this.email,
  });
  factory NormalUser.fromDocument(DocumentSnapshot doc) {
    return NormalUser(
      id: doc['id'],
      username: doc['username'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      displayName: doc['displayName'],
    );
  }
}
