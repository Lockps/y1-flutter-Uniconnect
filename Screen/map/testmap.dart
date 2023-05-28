import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';

class MapPost extends StatefulWidget {
  @override
  State<MapPost> createState() => _MapPostState();
}

class _MapPostState extends State<MapPost> {
  GoogleMapController? _googleMapController;
  List<Marker> markers = [];
  LatLng currentposition = LatLng(14.101590142678846, 100.98362357172329);
  GetLocation getLocation = GetLocation();
  bool _loadingLocation = false;

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
                  double latitude = document.get("lat");
                  double longitude = document.get("lng");

                  if (latitude != null && longitude != null) {
                    final latLng = LatLng(latitude, longitude);
                    markers.add(
                      Marker(
                          markerId: MarkerId(document.id),
                          position: latLng,
                          onTap: () {
                            setState(() {
                              isClicked = !isClicked;
                            });
                          },
                          infoWindow: InfoWindow(
                              title: "${latitude} and ${longitude}")),
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
    );
  }
}
