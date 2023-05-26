import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_project/components/my_button.dart';
import 'package:mobileapp_project/components/my_textfield.dart';
import 'package:colorful_background/colorful_background.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  Future signUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 226, 83, 83),
        body: ColorfulBackground(
          duration: const Duration(milliseconds: 2000),
          backgroundColors: const [
            Color.fromARGB(255, 253, 141, 141),
            Color.fromARGB(255, 255, 176, 176),
            Color.fromARGB(255, 189, 114, 114),
            Color.fromARGB(255, 190, 149, 149),
            Color.fromARGB(255, 248, 72, 72),
          ],
          // decoratorList is an optional attribute
          decoratorsList: [
            Positioned(
              top: MediaQuery.of(context).size.height / 2.5,
              left: MediaQuery.of(context).size.width / 2.5,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 20,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 90,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                        height: 240,
                        child: Image.network(
                            'http://unity.swu.ac.th/wp-content/uploads/2020/06/Srinakharinwirot_Logo_TH_Color-1-300x300.jpg')),

                    // logo

                    const SizedBox(height: 25),

                    // username textfield
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 10),

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      onTap: signUserIn,
                    ),

                    const SizedBox(height: 50),

                    // or continue with

                    // google + apple sign in buttons
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
