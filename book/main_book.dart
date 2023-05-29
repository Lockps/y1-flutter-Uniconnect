import 'package:flutter/material.dart';

import 'book1.dart';
import 'book2.dart';
import 'book3.dart';
import 'book4.dart';

class main_book extends StatelessWidget {
  const main_book({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return book1();
                }));
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/court.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(), // no shadow color set, defaults to black
                    ],
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("ครอส1",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return book2();
                }));
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/court.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(), // no shadow color set, defaults to black
                    ],
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("ครอส2",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return book3();
                }));
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/court.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(), // no shadow color set, defaults to black
                    ],
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("ครอส3",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return book4();
                }));
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/court.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(), // no shadow color set, defaults to black
                    ],
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("ครอส4",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }
}
