import 'package:flutter/material.dart';

class ChatColumn extends StatelessWidget {
  final List<Widget> messageBubbles;
  final TextEditingController messageTextController;
  final Function sendMessage;
  ChatColumn(
      {@required this.messageTextController,
      @required this.sendMessage,
      @required this.messageBubbles});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageTextController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    hintText: 'Type your message here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              FlatButton(
                onPressed: sendMessage,
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
