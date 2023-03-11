import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/LoginScreen.dart';
import 'package:flutter_chat/screens/Registration.dart';

class WelcomePage extends StatefulWidget {
  static const String id = "WelcomePage";
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 60.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const Text(
                'Super Chat',
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 48.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 8.0,
              color: Colors.grey,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Log In',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30.0),
              elevation: 8.0,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, Registration.id);
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Sign Up',
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
