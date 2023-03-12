import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/LoginScreen.dart';
import 'package:flutter_chat/screens/chatScreen.dart';
import '../screens/Registration.dart';
import '../screens/WelcomeScreen.dart';
import '../screens/chatScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const chatApp());
}
class chatApp extends StatelessWidget {
  static const String id = "mainPage";
  const chatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: ThemeData.dark().copyWith(
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black12)
      )
    ),
        initialRoute: WelcomePage.id,
        routes: {
          WelcomePage.id: (context) => const WelcomePage(),
          Registration.id: (context) => const Registration(),
          ChatScreen.id: (context) => const ChatScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
        }
    );
  }
}
