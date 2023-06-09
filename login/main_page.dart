import 'package:mobileapp_project/main.dart';
import 'package:mobileapp_project/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const FirstPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

final user = FirebaseAuth.instance.currentUser;
String email = user!.email!;
final name = email.split('@');
