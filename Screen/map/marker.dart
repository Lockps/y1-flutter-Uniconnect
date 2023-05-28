import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMarker {
  final databaseMarker =
      FirebaseFirestore.instance.collection("Post").snapshots();

  List<Marker> allMarker = [];
}
