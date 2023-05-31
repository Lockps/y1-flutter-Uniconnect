// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
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
  String? img;

  bool isClicked = false;

  String? urlpic;
  Uint8List? pic;

  String sampimg =
      'https://cdn.discordapp.com/attachments/981215902848655450/1112913522687492116/IMG_2426.png';

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
                    .animateCamera(CameraUpdate.newLatLngZoom(newLocation, 17));
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
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                markers.clear();

                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                for (var document in documents) {
                  String name = document.get("name");
                  double latitude = double.parse(document.get("lat"));
                  double longitude = double.parse(document.get("lng"));
                  String sampdata = document.get("warning");
                  String? sampimg = document.get('imgurl');

                  if (latitude != null && longitude != null) {
                    final latLng = LatLng(latitude, longitude);
                    markers.add(
                      Marker(
                        markerId: MarkerId(document.id),
                        position: latLng,
                        onTap: () {
                          _googleMapController!
                              .animateCamera(CameraUpdate.zoomTo(17));
                          setState(() {
                            // urlpic = urlimg;
                            isClicked = true;
                            data = sampdata;
                            img = sampimg;
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
            bottom: MediaQuery.of(context).size.height * 0.001,
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: parentHeight * 0.1,
                    ),
                    InkWell(
                      onTap: () {
                        print("$isClicked");
                        setState(() {
                          isClicked = !isClicked;
                        });
                      },
                      child: Container(
                        width: parentWidth * 0.2,
                        height: parentHeight * 0.05,
                        decoration: BoxDecoration(
                            color: myPalettesColor.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    SizedBox(
                      height: parentHeight * 0.1,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Spacer(),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  width: parentWidth * 0.3,
                                  height: parentWidth * 0.3,
                                  child: Container(
                                    width: parentWidth * 0.3,
                                    height: parentHeight * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withAlpha(150),
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                            image: NetworkImage("$img"),
                                            fit: BoxFit.cover)),
                                  )),
                              SizedBox(
                                height: parentHeight * 0.2,
                              ),
                              Container(
                                color: Colors.transparent,
                                width: parentWidth * 0.6,
                                height: parentHeight * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: const Color.fromARGB(
                                              255, 107, 107, 107),
                                        ),
                                        Text(
                                          "Post at ${currentposition.latitude}${currentposition.longitude}",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 107, 107, 107)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: parentHeight * 0.15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: parentWidth * 0.01,
                                        ),
                                        Text(
                                          "Problem is ${data}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
