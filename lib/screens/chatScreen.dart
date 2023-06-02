import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/WelcomeScreen.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
class ChatScreen extends StatefulWidget {
  static const String id = "ChatScreen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  late String _textMessage;
  final textMessageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  void getMessageStream() async {
    var db = await _firestore.collection('messages').orderBy('timestamp', descending:true).snapshots();
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
                  //getMessageStream();
                  _auth.signOut();
                  Navigator.pushNamed(context, WelcomePage.id);
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            'text': _textMessage,
                            'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch
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
  const MessageBubble(this.text, this.sender, this.isthisMe, {super.key});
  final String text;
  final String sender;
  final bool isthisMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isthisMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(sender,style: const TextStyle(fontSize: 14,color: Colors.grey),),
          Material(
            elevation: 5.0,
            borderRadius: isthisMe? const BorderRadius.only(topLeft: Radius.circular(36),
                                                  topRight: Radius.circular(36),
                                                  bottomRight: Radius.circular(0),
                                                  bottomLeft: Radius.circular(36),):
            const BorderRadius.only(topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
              bottomRight: Radius.circular(36),
              bottomLeft: Radius.circular(0),),

            color: isthisMe? Colors.blueAccent: Colors.grey,
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
      stream: _firestore.collection('messages').orderBy('timestamp', descending: true)
          .snapshots(),
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
        final messages = snapshot.data?.docs.reversed;
        for (var message in messages!) {
          final messageData = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentUser = loggedInUser.email;
          final messageWidget =
          MessageBubble(messageData, messageSender, currentUser==messageSender);
          messageBubbles.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            //reverse: true,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

