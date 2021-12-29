import 'package:dynamicapp/animate_do.dart';
import 'package:dynamicapp/controller/app_controler.dart';
import 'package:dynamicapp/home.dart';
import 'package:dynamicapp/services/dynamic_link.dart';
import 'package:dynamicapp/services/location_helper.dart';
import 'package:dynamicapp/services/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppControler appControler = Get.find();
  @override
  void initState() {
    LocationHelper().getCurrentLocation();
    appControler.getCustomIcon();
    Future.delayed(Duration(seconds: 3), () {
      Get.to(() => Home());
      NotificationHelper().initNotification();
      DynamicLink().retrieveDynamicLink();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ZoomIn(
          duration: Duration(seconds: 3),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
