// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/Screen/qrcode/qrcode.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  MyPalettesColor myPalettesColor = MyPalettesColor();

  GoogleMapController? googleMapController;
  LatLng position = LatLng(14.101590142678846, 100.98362357172329);
  GetLocation getLocation = GetLocation();
  bool _loadingLocation = false;

  bool isClicked = false;

  List<Marker> _list = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(14.101590142678846, 100.98362357172329))
  ];
  Set<Marker> allMarkers = {};

  void onMapcreate(GoogleMapController controller) {
    googleMapController = controller;
  }

  @override
  void initState() {
    allMarkers = Set<Marker>.of(_list);
    super.initState();
    getcurrentlocation();
  }

  Future<void> getcurrentlocation() async {
    LocationData? currentlocation = await getLocation.getLocationData();
    setState(() {
      _loadingLocation = true;
      if (currentlocation == null) {
        const SnackBar(
          content: Text("Location Error"),
        );
      } else {
        setState(() {
          position =
              LatLng(currentlocation.latitude!, currentlocation.longitude!);
          _loadingLocation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        actions: [
          IconButton(
              onPressed: () {
                getcurrentlocation();
                LatLng newLocation = position;
                googleMapController!
                    .animateCamera(CameraUpdate.newLatLng(newLocation));
                isClicked = !isClicked;
              },
              color: myPalettesColor.pink,
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GoogleMap(
                onMapCreated: onMapcreate,
                initialCameraPosition:
                    CameraPosition(target: position, zoom: 17),
                markers: allMarkers
                // {
                //   Marker(
                //     markerId: const MarkerId("Press for add accident"),
                //     position: position,
                //     onTap: () {},
                //     draggable: true,
                //   ),
                // },
                ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.0001,
              child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width,
                  height:
                      isClicked ? MediaQuery.of(context).size.height * 0.25 : 0,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  duration: Duration(seconds: 1)),
            )
          ],
        ),
      ),
    );
  }
}
