import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GetLocation {
  Location location = Location();
  late bool _isSericeEnable = false;
  late PermissionStatus _permissionStatus = PermissionStatus.denied;
  late LocationData locationData;

  Future<LocationData> getLocationData() async {
    if (!_isSericeEnable) getService();
    if (_permissionStatus != PermissionStatus.granted) getPermission();

    return locationData = await location.getLocation();
  }

  Future<void> getService() async {
    _isSericeEnable = await location.serviceEnabled();
    if (!_isSericeEnable) {
      _isSericeEnable = await location.requestService();
      if (!_isSericeEnable) {
        const SnackBar(
          content: Text("Service Error"),
        );
      }
    }
  }

  Future<void> getPermission() async {
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        const SnackBar(
          content: Text("Permission Failed"),
        );
      }
    }
  }
}
