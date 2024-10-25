import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:s3e_firebase/home.dart';
import 'package:s3e_firebase/model/app_user.dart';
import 'package:s3e_firebase/utils/file_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _storageRef = FirebaseStorage.instance.ref();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: () => _signOut(), child: Text('Sign Out'))
        ],
      ),
      body: Column(
        children: [
          imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 200,
                )
              : SizedBox(),
          ElevatedButton(
              onPressed: () => _saveRealTimeDb(),
              child: Text('Save user data')),
          ElevatedButton(
              onPressed: () => _viewRealTimeDb(),
              child: Text('View user data')),
          ElevatedButton(
              onPressed: () => _saveFirestoreDb(),
              child: Text('Save user data')),
          ElevatedButton(
              onPressed: () => _viewFirestoreDb(),
              child: Text('View user data')),
          ElevatedButton(
              onPressed: () => _uploadUserProfilePic(),
              child: Text('Upload Image'))
        ],
      ),
    );
  }

  _signOut() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
      (route) => false,
    );
  }

  _saveRealTimeDb() {
    AppUser _appUser = AppUser(
        displayName: 'Marwa Talaat',
        email: _auth.currentUser!.email!,
        phone: '01545645451',
        address: 'Mansoura');
    _db.child('users').child(_auth.currentUser!.uid).set(_appUser.toMap()).then(
      (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data Saved')));
      },
    );
  }

  _viewRealTimeDb() {
    _db.child('users').child(_auth.currentUser!.uid).onValue.listen(
      (event) {
        // print(event.type);
        // print(event.snapshot.value);
        // print(event.snapshot.value.runtimeType);
        Map<String, dynamic> result =
            Map.from(event.snapshot.value as Map<Object?, Object?>);
        // print(result);
        // print(result.runtimeType);
        AppUser user = AppUser.fromMap(result);
        print('Welcome ${user.displayName}');
      },
    );
  }

  _saveFirestoreDb() {
    AppUser _appUser = AppUser(
        displayName: 'Marwa Talaat',
        email: _auth.currentUser!.email!,
        phone: '01545645451',
        address: 'Mansoura');
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set(_appUser.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Data Saved')));
      },
    );
  }

  _viewFirestoreDb() {
    _firestore.collection('users').doc(_auth.currentUser!.uid).get().then(
      (value) {
        // print(value.data());
        // print(value.data().runtimeType);
        AppUser _appUser =
            AppUser.fromMap(value.data() as Map<String, dynamic>);
        print('Welcome ${_appUser.displayName}');
      },
    );
  }

  _uploadUserProfilePic() async {
    File? file = await FileUtils.pickIMage();
    if (file != null) {
      // print(file.path.split('/').last);
      UploadTask uploadTask = _storageRef
          .child(_auth.currentUser!.uid)
          .child('images')
          .child(file.path.split('/').last)
          .putFile(file);
      uploadTask.snapshotEvents.listen(
        (taskSnapshot) {
          print(
              'Progress ${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes * 100}');
        },
      );
      uploadTask.whenComplete(
        () async {
          imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
          updateUserdata();
          setState(() {});
        },
      );
    }
  }

  void updateUserdata() {
    //update Db
    _db
        .child('users')
        .child(_auth.currentUser!.uid)
        .update({'pic': imageUrl}).then(
      (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Updated Real time')));
      },
    );

    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({'pic': imageUrl}).then(
      (value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Updated Firestore')));
      },
    );
  }
}
