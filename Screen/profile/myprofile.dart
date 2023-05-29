// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../../book/main_book.dart';
import '../../main.dart';

final user = FirebaseAuth.instance.currentUser;
String email = user!.email!;
final name = email.split('@');
String imageurl =
    'https://static.independent.co.uk/s3fs-public/thumbnails/image/2015/06/06/15/Chris-Pratt.jpg?quality=75&width=990&crop=2048%3A1536%2Csmart&auto=webp';

class Proflie extends StatefulWidget {
  const Proflie({super.key});

  @override
  State<Proflie> createState() => _ProflieState();
}

class _ProflieState extends State<Proflie> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Future<String> uploadPdf(String filename, File file) async {
      final reference = FirebaseStorage.instance.ref().child("image/$filename");
      final uploadTask = reference.putFile(file);
      await uploadTask.whenComplete(() {});
      final downloadLink = await reference.getDownloadURL();
      return downloadLink;
    }

    void pickFile() async {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg'],
      );
      if (pickedFile != null) {
        String filename = pickedFile.files[0].name;
        File file = File(pickedFile.files[0].path!);
        final downloadLink = await uploadPdf(filename, file);
        await firebaseFirestore.collection("imageUpload").add({
          "name": filename,
          "url": downloadLink,
        });
        setState(() {
          imageurl = downloadLink;
        });
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 32, 32),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              ProfilePicture(
                name: 'Aditya Dharmawan Saputra',
                radius: 50,
                fontsize: 21,
                img: imageurl,
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                name[0],
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 14,
              ),
              Text(email, style: TextStyle(fontSize: 18, color: Colors.white)),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                onTap: () => pickFile(),
                child: Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.yellowAccent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("change profile",
                          style: TextStyle(
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return main_book();
                  }));
                },
                child: Container(
                  width: 300,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 77, 77, 77),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.lock_clock,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Booking",
                          style: TextStyle(fontSize: 22, color: Colors.white))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                width: 300,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 77, 77, 77),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.fastfood,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Order",
                        style: TextStyle(fontSize: 22, color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Container(
                  width: 140,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("logout",
                          style: TextStyle(
                            fontSize: 15,
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;