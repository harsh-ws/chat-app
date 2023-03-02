import 'package:flutter/material.dart';
import '../screens/WelcomeScreen.dart';

void main(){
  return runApp(chatApp());
}
class chatApp extends StatelessWidget {
  const chatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: ThemeData.dark().copyWith(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black12)
      )
    ),
      home: WelcomePage(),
    );
  }
}
