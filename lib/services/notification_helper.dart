import 'dart:convert';

import '../controller/app_controler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../notification_screen.dart';


class NotificationHelper {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  initNotification() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      Get.to(() => NotificationScreen());
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print('Message title: ${message.notification!.title!}');
      print('Message body: ${message.notification!.body!}');
       localNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: json.encode(message.data)
      );
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      Get.to(() => NotificationScreen());
      // if(message.data['type'] =='product'){
      //   print(message.data['productid']);
      // }
      print('onMessageOpenedApp title: ${message.notification!.title!}');
      print('onMessageOpenedApp body: ${message.notification!.body!}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    await FirebaseMessaging.instance.subscribeToTopic('all');
    getFcmToken();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  getFcmToken() async {
    String? fcmToken = await messaging.getToken();
    print('fcmToken  $fcmToken');
    return fcmToken;
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      // debugPrint('notification payload: $payload');
      print(payload);
      Map data = json.decode(payload);
      print('data selectNotification');
      print(data);
      Get.to(() => NotificationScreen());
    }
  }

  localNotification({
  required  String title,
    required  String body,
    required  String payload,
  }) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: payload);
  }
}
