import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s3e_firebase/home.dart';
import 'package:s3e_firebase/home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),
      () {
        if (_auth.currentUser == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(), //login
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        }
      },
    );

    return Scaffold();
  }
}
