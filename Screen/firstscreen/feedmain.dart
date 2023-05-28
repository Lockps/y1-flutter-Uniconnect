// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

  Future<void> _refreshdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Post")
        .orderBy("date", descending: true)
        .get();
  }

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
      body: Padding(
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
                    final header = data["header"] as String?;
                    final essays = data["essays"] as String?;
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        color: myPalettesColor.yellow.withAlpha(80),
                        border: Border(
                            bottom: BorderSide(
                                width: 1.5, color: Colors.black.withAlpha(50))),
                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Row(children: [
                              CircleAvatar(
                                radius: 30,
                              ),
                              Text("Lockky")
                            ]),
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            height: MediaQuery.of(context).size.height * 0.08,
                            //*DATA
                            child: ListTile(
                              title: Text(
                                header ?? "Doesn't found header",
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(essays ?? "Doesn't found essays"),
                            ),
                          ),
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * 0.04,
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
                                    onPressed: () {}, icon: Icon(Icons.share)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WritePost();
          }));
        },
        child: Icon(Icons.post_add),
      ),
    );
  }
}
