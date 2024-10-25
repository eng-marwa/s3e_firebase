import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s3e_firebase/home_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    //checkVerifiedEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () => _login('marwat@gmail.com', '123456'),
              child: Text('Login')),
          ElevatedButton(
              onPressed: () => _register('user@gmail.com', '123456'),
              child: Text('Register'))
        ],
      )),
    );
  }

  _login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? currentUser = userCredential.user;
      if (currentUser != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('login successfulll')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.code} - ${e.message}')));
    }
  }

  _register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('register successfulll')));
        Future.delayed(
          Duration(seconds: 3),
          () {
            _auth.currentUser!.sendEmailVerification();
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.code} - ${e.message}')));
    }
  }

  void checkVerifiedEmail() {
    if (_auth.currentUser != null && _auth.currentUser!.emailVerified) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Verify your account')));
    }
  }
}
