// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_build_context_synchronously, prefer_interpolation_to_compose_strings, empty_catches, avoid_print, unnecessary_null_comparison

import 'dart:io';

import 'dart:core';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/firstscreen/datapost.dart';

//*=====================PATH-FILE======================//

import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/Screen/profile/myprofile.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';

final user = FirebaseAuth.instance.currentUser;
String email = user!.email!;
final name = email.split('@');

class Feed extends StatefulWidget {
  const Feed({Key? key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  MyPalettesColor myPalettesColor = MyPalettesColor();
  CollectionReference _datapost = FirebaseFirestore.instance.collection("Post");
  GetLocation getLocation = GetLocation();
  bool isPost = false;
  double? currentLati;
  double? currentLng;
  String? addimage;
  Map<String, String> dataToSend = {};

  bool isOnCam = false;

  Future<void> _refreshdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Post")
        .orderBy("date", descending: true)
        .get();
  }

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

  GlobalKey<FormState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    CollectionReference dataWritePost =
        FirebaseFirestore.instance.collection("Post");
    DataPost post = DataPost(
        "Header", "essay", DateTime.now(), 1, getLocation.getLocationData(), 0);
    String imageUrl;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: isPost
            ? RoundedRectangleBorder()
            : RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
        backgroundColor: myPalettesColor.purple,
        title: Text(
          "All post today",
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(color: Colors.transparent),
              height: isPost ? MediaQuery.of(context).size.height * 0.20 : 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final parentWidth = constraints.maxWidth;
                  final parentHeight = constraints.maxHeight;
                  return Container(
                    decoration: BoxDecoration(color: myPalettesColor.purple),
                    width: MediaQuery.of(context).size.width,
                    height: parentHeight,
                    child: FutureBuilder(
                        future: Firebase.initializeApp(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          }
                          return Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Spacer(),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter text";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText:
                                              "${name[0]} want to post something?",
                                          suffixIcon: IconButton(
                                              onPressed: () async {
                                                ImagePicker imagePicker =
                                                    ImagePicker();
                                                XFile? file =
                                                    await imagePicker.pickImage(
                                                        source:
                                                            ImageSource.camera);

                                                String uniqueFileName =
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                Reference referenceRoot =
                                                    FirebaseStorage.instance
                                                        .ref();
                                                Reference referenceDirImages =
                                                    referenceRoot
                                                        .child('imgposturl');
                                                Reference
                                                    referenceImageToUpload =
                                                    referenceDirImages.child(
                                                        'name$uniqueFileName');
                                                await referenceImageToUpload
                                                    .putFile(File(file!.path));
                                                imageUrl =
                                                    await referenceImageToUpload
                                                        .getDownloadURL();
                                                setState(() {
                                                  addimage = imageUrl;
                                                  isOnCam = true;
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Upload Successful')));
                                              },
                                              icon: Icon(isOnCam
                                                  ? Icons.check
                                                  : Icons.camera_alt_rounded))),
                                      onSaved: (newValue) {
                                        post.essays = newValue!;
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              myPalettesColor.darkpink),
                                      label: Text(
                                          isOnCam ? "Post With photo" : "Post"),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          await getcurrentLatiLng();

                                          if (_formkey.currentState!
                                              .validate()) {
                                            post.date = DateTime.now();
                                            _formkey.currentState!.save();
                                            dataToSend["name"] = name[0];
                                            dataToSend["warning"] = post.essays;
                                            dataToSend["date"] =
                                                post.date.toString();
                                            dataToSend["icon"] =
                                                post.iconint.toString();
                                            dataToSend["like"] =
                                                post.like.toString();
                                            dataToSend["lat"] =
                                                currentLati.toString();
                                            dataToSend["lng"] =
                                                currentLng.toString();
                                            dataToSend["imgurl"] =
                                                addimage ?? "";
                                            _datapost.add(dataToSend);
                                            _formkey.currentState!.reset();
                                            setState(() {
                                              isPost = false;
                                            });
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.send),
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ));
                        }),
                  );
                },
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: RefreshIndicator(
                onRefresh: _refreshdata,
                color: Colors.red,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Post")
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, int index) {
                          final doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final name = data["name"] as String?;
                          final essays = data["warning"] as String?;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: BoxDecoration(
                              color: myPalettesColor.yellow.withAlpha(70),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.5,
                                      color: Colors.black.withAlpha(50))),
                            ),
                            child: Expanded(
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    color: Colors.transparent,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    child: Row(children: [
                                      ProfilePicture(
                                        name: name![0],
                                        radius: 35,
                                        fontsize: 21,
                                        img: imageprofile,
                                      ),
                                      Text("$name")
                                    ]),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent),
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    //*DATA
                                    child: Expanded(
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Text(
                                              essays ?? "Doesn't found header",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.thumb_up)),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.comment)),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.share)),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isPost = !isPost;
              isOnCam = false;
            });
          },
          backgroundColor: myPalettesColor.pink,
          child: Icon(
            isPost ? Icons.close : Icons.post_add,
            color: Colors.black.withAlpha(150),
          )),
    );
  }
}
