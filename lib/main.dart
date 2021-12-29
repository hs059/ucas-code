import 'dart:async';

import 'controller/app_controler.dart';
import 'package:dynamicapp/services/dynamic_link.dart';
import 'package:dynamicapp/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
// SystemChannels.platform.invokeMethod('SystemNavigator.pop');

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late Timer _timerLink;

  @override
  void initState() {
    super.initState();
    Get.put(AppControler());

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          DynamicLink().retrieveDynamicLink();
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}
// onWillPop: (){
//
// SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//
// return Future.value(true);
// },