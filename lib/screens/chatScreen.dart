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
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperChat'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, WelcomePage.id);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      backgroundColor: Colors.grey,
    );
  }
}
