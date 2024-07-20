import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/padding_extensions.dart';
import '../models/auth_config.dart';
import '../models/google_auth.dart';
import '../models/validator.dart';
import '../utils/hex_color.dart';
import '../utils/sharedpref_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool visibility = false;
  bool codeSent = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacementNamed(AppRouter.homeScreen);
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: null,
          body: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) {
              return FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      //display an error message
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return SingleChildScrollView(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Authenticator",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ).paddingOnly(top: 10, bottom: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#FFFFFF"),
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: email,
                                          validator: (value) =>
                                              Validator.validateEmail(
                                                  email: value),
                                          decoration: const InputDecoration(
                                            labelText: "Email",
                                            suffixIcon: Icon(Icons.person),
                                            //icon at head of input
                                          )).paddingSymmetric(horizontal: 25).paddingTop(10),
                                      TextFormField(
                                          controller: password,
                                          obscureText: visibility,
                                          validator: (value) =>
                                              Validator.validatePassword(
                                                password: value,
                                              ),
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    visibility = !visibility;
                                                  });
                                                },
                                                icon: Icon(Icons.visibility)),
                                            //icon at head of input
                                          )).paddingSymmetric(horizontal: 25),
                                      SizedBox(
                                        height: deviceSize.height * 0.06,
                                        width: deviceSize.width * 0.4,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              User? user =
                                              await FirebaseAuthHelper
                                                  .signInUsingEmailPassword(
                                                email: email.text,
                                                password: password.text,
                                              );

                                              setState(() {
                                                _isLoading = false;
                                              });

                                              if (user != null) {
                                                SharedPrefs().setUserEmail(email.text);
                                                SharedPrefs().setUserPassword(password.text);
                                              } else {
                                                const SnackBar(content: Text("Incorrect Data"));
                                              }
                                            }
                                          },
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 15, color: Colors.black),
                                          ),
                                        ),
                                      ).paddingOnly(top: 40,bottom: 20),

                                    ],
                                  ),
                                ),
                              ).paddingSymmetric(horizontal: 35),
                              const Text(
                                "Or Using",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).paddingOnly(top: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(AppRouter.phoneSignIn);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.phone,
                                        size: 20,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          await authProvider
                                              .signInWithGoogle(context);
                                          if (authProvider.user != null) {
                                            SharedPrefs().setUserEmail(
                                                authProvider.user!.email!);
                                            SharedPrefs().setUserName(
                                                authProvider
                                                    .user!.displayName!);
                                            // SharedPrefs().setPhotoURL(
                                            //     authProvider.user!.photoURL!);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                AppRouter.homeScreen);
                                          }
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                Text(error.toString())),
                                          );
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.google,
                                        color: Colors.red,
                                        size: 20,
                                      )),

                                  IconButton(
                                      onPressed: () {},
                                      icon: const FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.indigo,
                                        size: 20,
                                      )),

                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Dont have an account?",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ).paddingEnd(5),
                                  RichText(
                                    text: TextSpan(
                                        text: "Signup",
                                        style: TextStyle(
                                            color: Colors.blue.shade700),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                AppRouter.signUpScreen);
                                          }),
                                  ),
                                ],
                              ).paddingOnly(left: deviceSize.width * 0.24),
                              Visibility(
                                visible: _isLoading,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            ],
                          ).paddingTop(deviceSize.height * 0.2),
                        ),
                      );
                    }
                  });
            },
          ),
        ),
      ),
    );
  }
}
