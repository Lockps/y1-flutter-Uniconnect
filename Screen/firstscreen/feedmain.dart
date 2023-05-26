// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

//*=====================PATH-FILE======================//
import 'package:mobileapp_project/Screen/firstscreen/postscreen.dart';
import 'package:mobileapp_project/color/selectedcolor.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  MyPalettesColor myPalettesColor = MyPalettesColor();
  CollectionReference _datapost = FirebaseFirestore.instance.collection("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        backgroundColor: myPalettesColor.purple,
        title: Text(
          "All post today",
        ),
      ),
      body: StreamBuilder(
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
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, int index) {
                  late bool liked = false;
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final header = data["header"] as String?;
                  final essays = data["essays"] as String?;
                  final like = data["like"];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: myPalettesColor.pink,
                          boxShadow: [BoxShadow(blurRadius: 2)],
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Stack(children: [
                        ListTile(
                          title: Text(
                            header ?? "Doesn't found header",
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(essays ?? "Doesn't found essays"),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: InkWell(
                            onTap: () {},
                            child: LikeButton(
                              size: 40,
                              isLiked: liked,
                              likeCount: like,
                              likeBuilder: (isLiked) {
                                final color =
                                    isLiked ? Colors.red : Colors.grey;
                                return Icon(
                                  Icons.favorite,
                                  color: color,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
