import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roadcare/components/navigation_menu.dart';
import 'package:roadcare/pages/login_or_register_page.dart';
//import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MainLayout();
          }

          // user is NOT logged in
          else {
            return loginOrRegisterPage();
          }
        },
      ),
    );
  }
}