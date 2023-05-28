// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/firstscreen/datapost.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/Screen/map/map.dart';

class WritePost extends StatefulWidget {
  const WritePost({Key? key});

  @override
  State<WritePost> createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  GetLocation getLocation = GetLocation();
  double? currentLati;
  double? currentLng;

  Future<void> getcurrentLatiLng() async {
    LocationData? currentLocation = await getLocation.getLocationData();
    setState(() {
      if (currentLocation == null) {
        const SnackBar(content: Text("Location Error"));
      } else {
        currentLati = currentLocation.latitude;
        currentLng = currentLocation.longitude;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GetLocation getLocation = GetLocation();
    final _formkey = GlobalKey<FormState>();
    CollectionReference _datapost =
        FirebaseFirestore.instance.collection("Post");
    DataPost post = DataPost(
        "Header", "essay", DateTime.now(), 1, getLocation.getLocationData(), 0);
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Header"),
                    validator:
                        RequiredValidator(errorText: "Please enter header"),
                    onSaved: (newValue) {
                      post.header = newValue!;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Post?"),
                    onSaved: (newValue) {
                      post.essays = newValue!;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        await getcurrentLatiLng();
                        if (_formkey.currentState!.validate()) {
                          post.date = DateTime.now();
                          _formkey.currentState!.save();
                          _datapost.add({
                            "header": post.header,
                            "essays": post.essays,
                            "date": post.date,
                            "icon": post.iconint,
                            "like": post.like,
                            "lat": currentLati,
                            "lng": currentLng
                          });
                          _formkey.currentState!.reset();
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(Icons.post_add),
                      label: Text("label"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
