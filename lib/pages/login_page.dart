import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roadcare/components/my_button.dart';
import 'package:roadcare/components/my_textfield.dart';
import 'package:roadcare/components/square_tile.dart';
import 'package:roadcare/services/auth_service.dart';

class loginPage extends StatefulWidget {
  final Function()? onTap;
  loginPage({super.key, required this.onTap});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  //text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isGoogleSignInLoading = false; // Add a loading state for Google sign-in

  // Sign in function
  void signUserIn() async {
    // Show a loading indicator before the sign-in attempt
    final snackBar = SnackBar(
      content: const Text('Signing in...'),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Dismiss the "Signing in..." snackbar upon successful sign-in
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Navigate to another page or show a success message here if needed
    } on FirebaseAuthException catch (e) {
      // Dismiss the "Signing in..." snackbar before showing error message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      String errorMessage = 'An error occurred. Please try again later.'; // Default error message

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Incorrect email or password'; // Generic message for authentication errors
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Google Sign-in function with loading state
  void handleGoogleSignIn() async {
    setState(() {
      isGoogleSignInLoading = true; // Start loading
    });

    try {
      await AuthService().signInWithGoogle();
      // Navigate to the next page or perform some action upon successful sign-in
      setState(() {
        isGoogleSignInLoading = false; // Stop loading on success
      });
    } catch (error) {
      // Handle error or cancellation
      setState(() {
        isGoogleSignInLoading = false; // Stop loading on error
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                
                //logo
                SizedBox(
                  width: 150, 
                  height: 150,
                  child: Image.asset('lib/images/IIUMRoadCareLogo.png'),
                ),
            
                const SizedBox(height: 25),
            
                //sign in text
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),
            
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  text: "Login",
                  onTap: signUserIn,
                ),
            
                const SizedBox(height: 25),
            
                //or continue with text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          thickness: 0.5,
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                  
                      Expanded(
                        child: Divider(
                          color: Colors.grey[400],
                          thickness: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //google sign in button
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: isGoogleSignInLoading ? null : handleGoogleSignIn, // Use the loading state to control onTap
                      imagePath: 'lib/images/GoogleLoginIcon.png',
                      isLoading: isGoogleSignInLoading, // Pass the loading state to SquareTile
                    ),
                  ],
                ),
            
                const SizedBox(height: 50),
            
                //Don't have an account? Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ]),
          ),
        ),
      ),
    );
  }
}