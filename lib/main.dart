import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:s3e_firebase/item_details.dart';
import 'package:s3e_firebase/splash.dart';
import 'package:s3e_firebase/utils/notification_handler.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var instance = FirebaseMessaging.instance;
  String? token = await instance.getToken();
  if (token != null) {
    //send it to backend using api service
    print('FCM Token $token');
  }
  instance.onTokenRefresh.listen(
    (newToken) {
      //send it to backend using api service
      print('Token Refresh $newToken');
    },
  );
  if (await NotificationHandler.getPermission()) {
    NotificationHandler.initialize();
  }
  NotificationHandler.handleForegroundNotification();
  NotificationHandler.handleBackgroundNotification();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Splash(),
      routes: {'/item': (context) => const ItemDetails()},
    );
  }
}
