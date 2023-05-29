import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class UPLOAD extends StatefulWidget {
  const UPLOAD({super.key});
  @override
  State<UPLOAD> createState() => _UPLOADState();
}

class _UPLOADState extends State<UPLOAD> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Future<String> uploadFILE(String filename, File file) async {
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
        final downloadLink = await uploadFILE(filename, file);
        await firebaseFirestore.collection("imageUpload").add({
          "name": filename,
          "url": downloadLink,
        });
      }
    }

    return MaterialButton(
        color: Colors.amber,
        child: const Text("upload image"),
        onPressed: () => pickFile());
  }
}
