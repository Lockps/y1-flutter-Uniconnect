// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobileapp_project/Screen/firstscreen/feedmain.dart';
import 'package:mobileapp_project/Screen/firstscreen/postscreen.dart';
import 'package:mobileapp_project/Screen/map/map.dart';
import 'package:mobileapp_project/login/main_page.dart';
import 'firebase_options.dart';
import 'login/login_page.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int indexWidget = 0;
  List<Widget> _selectedWidget = <Widget>[Feed(), WritePost(), LocationMap()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.grey),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _selectedWidget.elementAt(indexWidget)),
      bottomNavigationBar: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              tabBackgroundColor: Colors.lightBlue,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'home',
                ),
                GButton(
                  icon: Icons.add,
                  text: 'add',
                ),
                GButton(
                  icon: Icons.map,
                  text: 'map',
                )
              ],
              selectedIndex: indexWidget,
              onTabChange: (value) {
                setState(() {
                  indexWidget = value;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
