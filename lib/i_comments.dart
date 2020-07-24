//  sendMessage() {
//    if (currentLoggedInUser.email == currentUser.email) {
//      Firestore.instance.collection('chat').add({
//        'text': messageText,
//        'sender': currentUser.email,
//        'time': Timestamp.now(),
//        'peer_id': peerUserId,
//        'current_id': currentUser.id,
//      });
//    } else {
//      Firestore.instance.collection('chat').add({
//        'text': messageText,
//        'sender': currentUser.email,
//        'time': Timestamp.now(),
//        'peer_id': currentUser.id,
//        'current_id': peerUserId,
//      });
//    }
//    messageTextController.clear();
//  }

//class ChattingPage extends StatefulWidget {
//  final User currentUser;
//  ChattingPage({this.currentUser});
//  @override
//  _ChattingPageState createState() => _ChattingPageState();
//}
//
//class _ChattingPageState extends State<ChattingPage> {
//  final usersRef = Firestore.instance.collection('users');
//  Future<QuerySnapshot> getData() async {
//    final QuerySnapshot data = await usersRef.getDocuments();
//    data.documents.forEach((element) {
//      print(widget.currentUser.id);
//    });
//    return data;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: FutureBuilder<QuerySnapshot>(
//          future: getData(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) {
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            }
//            List<DocumentSnapshot> uu = snapshot.data.documents;
//            List<Map<String, dynamic>> newData = [];
//            for (DocumentSnapshot loop in uu) {
//              if (loop.data['id'] == widget.currentUser.id) {
//                continue;
//              }
//              newData.add(loop.data);
//            }
//
//            return ListView.builder(
//              itemBuilder: (context, index) {
//                return GestureDetector(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ChatScreen(
//                                currentUser: widget.currentUser,
//                                peerUserEmail: newData[index]['email'],
//                                peerUserId: newData[index]['id'])));
//                  },
//                  child: ListTile(
//                    title: Text(newData[index]['email']),
//                  ),
//                );
//              },
//              itemCount: newData.length,
//            );
//          },
//        ),
//      ),
//    );
//  }
//}
