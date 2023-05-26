import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/Screen/qrcode/qrcode.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController? googleMapController;
  LatLng position = const LatLng(14.101590142678846, 100.98362357172329);
  GetLocation getLocation = GetLocation();
  bool _loadingLocation = false;

  void onMapcreate(GoogleMapController controller) {
    googleMapController = controller;
  }

  @override
  void initState() {
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
                showDialog(
                    context: context,
                    builder: (context) {
                      return QrGen();
                    });
              },
              icon: Icon(Icons.qr_code))
        ],
      ),
      body: GoogleMap(
        onMapCreated: onMapcreate,
        initialCameraPosition: CameraPosition(target: position, zoom: 17),
        markers: {
          Marker(
            markerId: const MarkerId("Press for add accident"),
            position: position,
            onTap: () {},
            draggable: true,
          ),
        },
      ),
    );
  }
}
