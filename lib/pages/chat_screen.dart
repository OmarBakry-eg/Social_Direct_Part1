import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialdirect_app/models/user.dart';
import 'package:socialdirect_app/widgets/chat_column.dart';
import 'package:socialdirect_app/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  ChatScreen({
    @required this.currentUser,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController;
  sendMessage() {
    Firestore.instance.collection('chat').add({
      'text': messageTextController.text,
      'sender': widget.currentUser.email,
      'time': Timestamp.now(),
    });
    messageTextController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messageTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var messages = snapshot.data.documents;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageTextRef = message.data['text'];
            final messageSenderRef = message.data['sender'];

            final messageBubble = MessageBubble(
              sender: messageSenderRef,
              text: messageTextRef,
              isMe: widget.currentUser.email == messageSenderRef,
            );

            messageBubbles.add(messageBubble);
          }

          return ChatColumn(
              messageTextController: messageTextController,
              sendMessage: sendMessage,
              messageBubbles: messageBubbles);
        },
        stream: Firestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
      ),
    ));
  }
}
