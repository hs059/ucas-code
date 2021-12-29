// import 'package:geocoding/geocoding.dart';
import 'package:dynamicapp/controller/app_controler.dart';
import 'package:flutter/material.dart';
 import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';

class LocationHelper {
  Geolocator? geolocator;
  AppControler appControler = Get.find();

  // Future<Geolocator?> initGeolocator() async {
  //   if (geolocator == null) {
  //     // geolocator = Geolocator()..forceAndroidLocationManager;
  //     return geolocator;
  //   } else {
  //     return geolocator;
  //   }
  // }

  getCurrentLocation() async {
    // geolocator = await initGeolocator();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      this.getPlaceName(position.latitude, position.latitude);

      appControler.setMyLatLong(position.latitude, position.longitude);

      // getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      Get.defaultDialog(
        title: '',
        // textConfirm: '       Enable my location       ',
        // confirmTextColor: Colors.white,
        // middleText:'Please enable to use your location to show nearby services on the map' ,
        content: Column(
          children: [
            Icon(
              Icons.my_location_outlined,
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              'Enable Your Location',
            ),
            SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(maxWidth: 235),
              child: Text(
                  'Please enable to use your location to show nearby services on the map'),
            ),
            SizedBox(height: 44),
            TextButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: Text('Enable my location'),
            )
          ],
        ),
        onWillPop: () {
           print('تتهبلش');
          return Future.value(false);
        },
      );

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // geolocator = await initGeolocator();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this.getPlaceName(position.latitude, position.latitude);

      // appControler.setMyLatLong(position.latitude, position.longitude);
    }).catchError((e) {
      print(e);
    });
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future getPlaceName(double lat, double long) async {

    try {
       List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Logger().d(placemarks);
      Logger().d(placemarks.first.name);
      appControler.address.value = placemarks.first.name!;
      // print('fffffffff ${appControler.address.value}');
    } catch (e) {}
  }
}
