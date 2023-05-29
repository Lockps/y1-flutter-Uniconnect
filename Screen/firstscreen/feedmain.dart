// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:mobileapp_project/Screen/firstscreen/datapost.dart';

//*=====================PATH-FILE======================//

import 'package:mobileapp_project/Screen/firstscreen/postscreen.dart';
import 'package:mobileapp_project/Screen/map/getlocation.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';
import 'package:mobileapp_project/test.dart';

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

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    CollectionReference dataWritePost =
        FirebaseFirestore.instance.collection("Post");
    DataPost post = DataPost(
        "Header", "essay", DateTime.now(), 1, getLocation.getLocationData(), 0);
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
                                                final camera =
                                                    await availableCameras();
                                                final firstcamera =
                                                    camera.first;

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TakePictureScreen(
                                                                camera:
                                                                    firstcamera)));
                                              },
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color:
                                                    Colors.white.withAlpha(200),
                                              ))),
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
                                      label: Text("Post"),
                                      onPressed: () async {
                                        if (_formkey.currentState!.validate()) {
                                          await getcurrentLatiLng();
                                          setState(() {
                                            isPost = false;
                                          });
                                          if (_formkey.currentState!
                                              .validate()) {
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
              padding: const EdgeInsets.only(top: 10),
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
                            child: Column(
                              children: [
                                Spacer(),
                                Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: Row(children: [
                                    CircleAvatar(
                                      radius: 30,
                                    ),
                                    Text("$name")
                                  ]),
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.transparent),
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  //*DATA
                                  child: ListTile(
                                    title: Text(
                                      essays ?? "Doesn't found header",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
