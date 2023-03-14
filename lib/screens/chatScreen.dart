import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/WelcomeScreen.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String id = "ChatScreen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String _textMessage;
  final textMessageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  void getMessageStream() async {
    var db = await _firestore.collection('messages').snapshots();
    await for (var snapshot in db) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SuperChat'),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  getMessageStream();
                  //_auth.signOut();
                  //Navigator.pushNamed(context, WelcomePage.id);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        //backgroundColor: Colors.grey,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: textMessageController,
                        onChanged: (value) {
                          _textMessage = value;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          textMessageController.clear();
                          _firestore.collection('messages').add({
                            'sender': loggedInUser.email,
                            'text': _textMessage
                          });
                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.text, this.sender);
  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(8),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,style: const TextStyle(fontSize: 14,color: Colors.grey),),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(24),
            color: Colors.blueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
          snapshot) {
        List<Widget> children;
        List<MessageBubble> messageBubbles = [];
        if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Stack trace: ${snapshot.stackTrace}'),
            ),
          ];
        } else if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
        }
        var messages = snapshot.data?.docs;
        for (var message in messages!) {
          final messageData = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageWidget =
          MessageBubble(messageData, messageSender);
          messageBubbles.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

