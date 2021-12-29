import 'dart:async';

import 'package:dynamicapp/controller/app_controler.dart';
import 'package:dynamicapp/directions_model.dart';
import 'package:dynamicapp/directions_repository.dart';
import 'package:dynamicapp/my_library.dart';
import 'package:dynamicapp/services/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  AppControler appControler = Get.find();
  // Directions? _info;

  List latLong = [
    '31.5219406,34.453096',
    '31.407038,34.3297314',
    '31.2795339,34.2931137',
    '31.5325508,34.4523132',
  ];
  // _getCurrentLocation() {
  //   Geolocator.getPositionStream(locationSettings:   LocationSettings(
  //       distanceFilter: 100, accuracy: LocationAccuracy.best),)
  //       .listen((Position position) {
  //
  //     appControler.latMap.value = position.latitude;
  //     appControler.longMap.value = position.longitude;
  //
  //     // if(_controller!=null){ _controller.animateCamera(CameraUpdate.newCameraPosition(
  //     //   CameraPosition(target: LatLng(_currentPosition.latitude,
  //     //       _currentPosition.longitude), zoom: 15),
  //     // ),
  //     //
  //     //
  //     //   // print(_currentPosition.longitude.toString());
  //     //   // Get.snackbar('currentPosition', _currentPosition.longitude.toString());
  //     //   // setState(() {
  //     //   //
  //     //   // });
  //     //
  //     // );}
  //     // _getAddressFromLatLng();
  //   });
  // }
  getAllMarkers() async {
    for (int i = 0; i < latLong.length; i++) {
      allMarkers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(double.parse(latLong[i].toString().split(',')[0]),
              double.parse(latLong[i].toString().split(',')[1])),
          icon: appControler.iconMarker,
//position:   LatLng(34.45179483583927,31.51460885866612),
//           icon: appControler.iconMarker,
          infoWindow: InfoWindow(title: '$i'),
          onTap: () {
            // getStore()
          }));
      // final directions = await DirectionsRepository().getDirections(
      //     origin:
      //         LatLng(appControler.latMyLocation, appControler.longMyLocation),
      //     destination: LatLng(double.parse(latLong[1].toString().split(',')[0]),
      //         double.parse(latLong[1].toString().split(',')[1])));
      // setState(() => _info = directions!);

    }
  }

  Set<Marker> allMarkers = <Marker>{};
  static late CameraPosition myLocation;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  changeMarkerTap(double lat, double long) {
    allMarkers.add(Marker(
      markerId: MarkerId('change'),
      position: LatLng(lat, long),
    ));
    setState(() {

    });
  }

  @override
  void initState() {
    getAllMarkers();
    myLocation = CameraPosition(
      target: LatLng(appControler.latMyLocation, appControler.longMyLocation),
      zoom: 14.4746,
    );
    // changeMarkerTap(appControler.latMyLocation, appControler.longMyLocation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // _info == null
            //     ? CircularProgressIndicator()
            //     :
            GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.satellite,
                    markers: allMarkers,
                    // polylines: {
                    //   if (_info != null)
                    //     Polyline(
                    //       polylineId: const PolylineId('overview_polyline'),
                    //       color: const Color(0xFF027A8A),
                    //       width: 5,
                    //       points: _info!.polylinePoints
                    //           .map((e) => LatLng(e.latitude, e.longitude))
                    //           .toList(),
                    //     ),
                    // },
                    // onTap: (argument) {
                    //   changeMarkerTap(argument.latitude, argument.longitude);
                    // },
                    onCameraMove: (position) {
                      Logger().d(position.target.longitude);
                      appControler.latMap.value = position.target.latitude;
                      appControler.longMap.value = position.target.longitude;
                      appControler.loadAddress.value = true;
                    },
                    onCameraIdle: () async {
                      await LocationHelper().getPlaceName(
                          appControler.latMap.value,
                          appControler.longMap.value);
                      appControler.loadAddress.value = false;
                    },
                    initialCameraPosition: myLocation,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/shopping-basket.png',
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: appControler.loadAddress.value
                        ? CircularProgressIndicator()
                        : Text(appControler.address.value),
                  ),
                ],
              ),
            ),
            // if (_info != null)
            //   Padding(
            //     padding: EdgeInsets.only(top: 40.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 6.0,
            //             horizontal: 12.0,
            //           ),
            //           decoration: BoxDecoration(
            //             color: Colors.yellowAccent,
            //             borderRadius: BorderRadius.circular(20.0),
            //             boxShadow: const [
            //               BoxShadow(
            //                 color: Colors.black26,
            //                 offset: Offset(0, 2),
            //                 blurRadius: 6.0,
            //               )
            //             ],
            //           ),
            //           child: Text(
            //             '${_info!.totalDistance}, ${_info!.totalDuration}',
            //             style: const TextStyle(
            //               fontSize: 18.0,
            //               fontFamily: 'Gotham Pro',
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //         SizedBox()
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

// Future<void> _goToTheLake() async {
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// }
}
