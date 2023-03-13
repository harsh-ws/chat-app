import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/WelcomeScreen.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "ChatScreen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String _textMessage;
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
    // final messages = await _firestore.collection('messages').snapshots();
    // for (message in )
  }

  // void getMessages() async{
  //   //final messages = await _firestore.collection('messages').get();
  //   final messages = _firestore.collection("messages");
  //   messages.get().then(
  //   (querySnapshot) {
  //   for (var docSnapshot in querySnapshot.docs) {
  //   print('${docSnapshot.id} => ${docSnapshot.data()}');
  //   }
  //   },
  //   onError: (e) => print("Error completing: $e"),
  //   );
  // }
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
              StreamBuilder(
                stream: _firestore.collection('messages').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  List<Widget> children;
                  List<Text> messageWidgets = [];
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
                        Text('$messageData from $messageSender');
                    messageWidgets.add(messageWidget);
                  }

                  return Column(
                    children: messageWidgets,
                  );
                },
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
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
