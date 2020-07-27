import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';
import 'feed.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResult;
  final CollectionReference userRef = Firestore.instance.collection('users');
  handelSearch(String query) {
    Future<QuerySnapshot> users =
        userRef.where('username', isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResult = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar searchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search for users',
          filled: true,
          prefix: Icon(
            Icons.account_box,
            size: 28.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handelSearch,
      ),
    );
  }

  buildNoContent() {
    return Center(
      child: Text('Find Users'),
    );
  }

  FutureBuilder<QuerySnapshot> buildSearchResult() {
    return FutureBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<UserResult> searchUsersResult = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult userResult = UserResult(user);
          searchUsersResult.add(userResult);
        });
        return ListView(
          children: searchUsersResult,
        );
      },
      future: searchResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: searchAppBar(),
      body: searchResult == null ? buildNoContent() : buildSearchResult(),
    ));
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, currentUser: user),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
