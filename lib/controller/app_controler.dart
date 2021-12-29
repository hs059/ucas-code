import 'dart:io';
import 'dart:typed_data';

import 'package:dynamicapp/my_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'dart:ui'as ui;
class AppControler extends GetxController {
  bool dlFlag = false;
  var dataAllUsers = [].obs;


  setDlFlag(bool value) {
    this.dlFlag = value;
    update();
  }
  Map notificationData = {};
  setNotificationData(Map value){
    this.notificationData = value ;
    update();
  }

  double latMyLocation = 0.0;

  double longMyLocation = 0.0;

  setMyLatLong(double lat, double long) {
    this.latMyLocation = lat;
    this.longMyLocation = long;
    update();
  }

  RxDouble latMap = 0.0.obs;

  RxDouble longMap = 0.0.obs;

  RxString address = ''.obs;

  RxBool loadAddress = false.obs;

  late BitmapDescriptor iconMarker;

  getCustomIcon() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(16, 16)), 'assets/images/football-field-pin.png')
        .then((onValue) {
      iconMarker = onValue;
    });
     update();
  }

// static Future<Uint8List> getBytesFromAsset(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//       targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//       .buffer
//       .asUint8List();
// }
//

}
