// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/Screen/profile/myprofile.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';

class MapPost extends StatefulWidget {
  @override
  State<MapPost> createState() => _MapPostState();
}

class _MapPostState extends State<MapPost> {
  MyPalettesColor myPalettesColor = MyPalettesColor();
  GoogleMapController? _googleMapController;
  List<Marker> markers = [];
  LatLng currentposition = LatLng(14.101590142678846, 100.98362357172329);
  GetLocation getLocation = GetLocation();
  bool _loadingLocation = false;

  String? data;

  bool isClicked = false;

  @override
  void initState() {
    getcurrentlocation();
    super.initState();
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
          currentposition =
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
        title: Text("Location Post"),
        backgroundColor: myPalettesColor.purple,
        actions: [
          IconButton(
              onPressed: () {
                getcurrentlocation();
                LatLng newLocation = currentposition;
                _googleMapController!
                    .animateCamera(CameraUpdate.newLatLng(newLocation));
              },
              icon: Icon(Icons.location_on))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Post").snapshots(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                markers.clear();

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                for (var document in documents) {
                  String name = document.get('name');
                  double latitude = document.get("lat");
                  double longitude = document.get("lng");
                  String sampdata = document.get('warning');

                  if (latitude != null && longitude != null) {
                    final latLng = LatLng(latitude, longitude);
                    markers.add(
                      Marker(
                        // icon: x ?? BitmapDescriptor.defaultMarker,
                        markerId: MarkerId(document.id),
                        position: latLng,
                        onTap: () {
                          setState(() {
                            isClicked = true;
                            data = sampdata;
                          });
                        },
                        infoWindow: InfoWindow(title: "${name}"),
                      ),
                    );
                  }
                }

                return GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: currentposition, zoom: 17),
                  markers: Set<Marker>.from(markers),
                  onMapCreated: (controller) {
                    _googleMapController = controller;
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.0008,
            child: AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              height: isClicked ? MediaQuery.of(context).size.height * 0.25 : 0,
              decoration: BoxDecoration(
                color: myPalettesColor.pink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              duration: Duration(seconds: 1),
              child: LayoutBuilder(builder: (context, constraints) {
                final parentWidth = constraints.maxWidth;
                final parentHeight = constraints.maxHeight;
                return Container(
                  color: Colors.transparent,
                  width: parentWidth * 0.8,
                  height: parentHeight * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: parentHeight * 0.1),
                      InkWell(
                        onTapDown: (details) {
                          setState(() {
                            isClicked = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: myPalettesColor.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: parentWidth * 0.2,
                          height: parentHeight * 0.05,
                        ),
                      ),
                      SizedBox(
                        height: parentHeight * 0.05,
                      ),
                      Container(
                        width: parentWidth * 0.8,
                        height: parentHeight * 0.2,
                        alignment: Alignment.center,
                        child: Text(
                          "Information",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: parentHeight * 0.01),
                      Container(
                        width: parentWidth * 0.8,
                        height: parentHeight * 0.2,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: parentWidth * 0.1),
                            Icon(Icons.location_on,
                                size: 20,
                                color: isClicked
                                    ? Colors.grey
                                    : Colors.transparent),
                            SizedBox(width: 5),
                            Text(
                              "From ${currentposition.latitude} and ${currentposition.longitude}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: parentHeight * 0.05),
                      Container(
                        width: parentWidth * 0.8,
                        height: parentHeight * 0.1,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: parentWidth * 0.10),
                            Icon(Icons.warning,
                                size: 20,
                                color: isClicked
                                    ? Colors.red
                                    : Colors.transparent),
                            SizedBox(width: 5),
                            Text(
                              "Accident: $data",
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

// Uint8List? markerimagess;
// Future<Uint8List> getasset(String path,int width) async{
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec =  await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight:width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   return (await fi.image.toByteData(format))
// }