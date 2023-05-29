// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/firstscreen/datapost.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';

class WritePost extends StatefulWidget {
  const WritePost({Key? key});

  @override
  State<WritePost> createState() => _WritePostState();
}

final user = FirebaseAuth.instance.currentUser;
String email = user!.email!;
final name = email.split('@');

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
    MyPalettesColor myPalettesColor = MyPalettesColor();
    GetLocation getLocation = GetLocation();
    final _formkey = GlobalKey<FormState>();
    CollectionReference _datapost =
        FirebaseFirestore.instance.collection("Post");
    DataPost post = DataPost(
        "Header", "essay", DateTime.now(), 1, getLocation.getLocationData(), 0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myPalettesColor.purple,
      ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "${name[0]} want to post something?",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () async {
                                    await getcurrentLatiLng();
                                    if (_formkey.currentState!.validate()) {
                                      post.date = DateTime.now();
                                      _formkey.currentState!.save();
                                      _datapost.add({
                                        "name": name[0],
                                        "warning": post.essays,
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
                                )),
                            onSaved: (newValue) {
                              post.essays = newValue!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            width: 50,
                            height: 50,
                            child: Icon(Icons.camera),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            width: 50,
                            height: 50,
                            child: Icon(Icons.file_download),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
