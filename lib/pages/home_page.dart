import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadcare/pages/auth_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  static const LatLng _GooglePlex = LatLng(3.252161672150421, 101.73425857314945);

  void signUserOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  
  // Navigate to the login screen and remove all routes from the stack
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => AuthPage()),
    (Route<dynamic> route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 70, 
          height: 70,
          child: Image.asset('lib/images/IIUMRoadCareLogo.png'), // Use your image as the title
        ),
        centerTitle: true, // This will center the title widget
        actions: [
          IconButton(
            onPressed: () => signUserOut(context), // Pass the context here
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _GooglePlex,
            zoom: 16
          )
        ),
      ),
    );
  }
}