import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  double latitude;
  double longitude;
  MapScreen({Key key, @required this.latitude, @required this.longitude}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState(latitude:latitude, longitude:longitude);
}

class _MapScreenState extends State<MapScreen> {
  double longitude;
  double latitude;
  _MapScreenState({Key key, @required this.latitude, @required this.longitude});

  @override
  Widget build(BuildContext context){
    var _initialCameraPosition = CameraPosition(
      target:  LatLng(latitude, longitude),
      zoom: 20,
    );
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
      ),
    );
  }

}