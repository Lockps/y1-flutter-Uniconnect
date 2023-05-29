// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';

void main(List<String> args) {
  runApp(QrGen());
}

class QrGen extends StatefulWidget {
  const QrGen({Key? key}) : super(key: key);

  @override
  State<QrGen> createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  late LocationData locationData;
  String? _data;

  @override
  void initState() {
    super.initState();
    initializeLocation();
  }

  void initializeLocation() async {
    GetLocation getLocation = GetLocation();
    locationData = await getLocation.getLocationData();
    setState(() {
      var result = DateTime.now().add(Duration(minutes: 30));
      var hour = result.hour.toString().padLeft(2, '0');
      var minute = result.minute.toString().padLeft(2, '0');
      var second = result.second.toString().padLeft(2, '0');
      var day = result.day.toString().padLeft(2, '0');
      var month = result.month.toString().padLeft(2, '0');
      var year = result.year.toString();

      _data =
          "65109010303\nคุณ\nฤกษ์พศวัฒน์ สัจจาพันธุ์\nKhun.\nROEKPASAWAT SAJJAPAN\n900\n\n${locationData.latitude!.toStringAsFixed(6)}\n${locationData.longitude!.toStringAsFixed(7)}\n$hour:$minute:$second\n\n$day/$month/$year\nUNI_MQR";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _data != null
              ? QrImageView(
                  data: _data!,
                  version: QrVersions.auto,
                  size: 200,
                )
              : CircularProgressIndicator()),
    );
  }
}
