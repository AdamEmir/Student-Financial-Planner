import 'package:email_validator/email_validator.dart';
import 'package:firstly/homepage.dart';
import 'package:firstly/screens/resetpassword_screen.dart';
import 'package:firstly/screens/signup_screen.dart';
import 'package:firstly/screens/signuptest.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninTestScreen extends StatefulWidget {
  const SigninTestScreen({super.key});

  @override
  State<SigninTestScreen> createState() => _SigninTestScreenState();
}

class _SigninTestScreenState extends State<SigninTestScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        )),
        alignment: AlignmentDirectional(0.00, -1.00),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 16),
                child: Container(
                  width: 300,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: AlignmentDirectional(0.00, 0.00),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 570,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 36.0,
                                  color: Color(0xFF101213)),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 24),
                              child: Text(
                                'Fill out the information below in order to access your account.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: Color(0xFF57636C)),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? 'Enter a valid email'
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Color(0xFF57636C)),
                                    alignLabelWithHint: false,
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                        color: Color(0xFF57636C)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFF1F4F8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF9489F5),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE74852),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF1F4F8),
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Color(0xFF101213)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: passwordController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      value != null && value.length < 6
                                          ? 'Enter min. 6 characters'
                                          : null,
                                  obscureText:
                                      true, // Set this property to true for password behavior
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Color(0xFF57636C),
                                    ),
                                    alignLabelWithHint: false,
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                      color: Color(0xFF57636C),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFF1F4F8),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF9489F5),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE0E3E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFE74852),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF1F4F8),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: Color(0xFF101213),
                                  ),
                                  keyboardType: TextInputType
                                      .visiblePassword, // Use TextInputType.visiblePassword for password fields
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 1,
                                    )),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Color(0xFF6D5FED);
                                      }
                                      return Color(0xFF9489F5);
                                    }),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    signIn();
                                  },
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // You will have to add an action on this rich text to go to your login page.
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the SignUpScreen when the text is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpTestScreen()), // Replace SignUpScreen with the actual screen you want to navigate to
                                  );
                                },
                                child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Don\'t have an account?  ',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text: 'Sign Up here',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                            color: Color(0xFF9489F5)),
                                      )
                                    ],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Color(0xFF101213)),
                                  ),
                                ),
                              ),
                            ),

                            ///You will have to add an action on this rich text to go to your login page.
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigate to the SignUpScreen when the text is clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordScreen()), // Replace SignUpScreen with the actual screen you want to navigate to
                                  );
                                },
                                child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Forgot Password?  ',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text: 'Reset',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                            color: Color(0xFF9489F5)),
                                      )
                                    ],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Color(0xFF101213)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print("Successfully login");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      Fluttertoast.showToast(
        msg: "Successfully login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseAuthException catch (error) {
      print("Error: ${error.toString()}");
      String errorMessage = "Invalid email or password";
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
