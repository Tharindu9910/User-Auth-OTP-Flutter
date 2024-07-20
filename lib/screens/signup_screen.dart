import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/padding_extensions.dart';
import '../models/auth_config.dart';
import '../models/validator.dart';
import '../utils/hex_color.dart';
import '../utils/sharedpref_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  bool visibility = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: null,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create New Account",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ).paddingOnly(top: 10, bottom: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: HexColor("#FFFFFF"),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: name,
                              validator: (value) =>
                                  Validator.validateName(name: value),
                              decoration: const InputDecoration(
                                labelText: "Name",
                                suffixIcon: Icon(Icons.person),
                                //icon at head of input
                              )).paddingSymmetric(horizontal: 25).paddingTop(10),
                          TextFormField(
                              controller: email,
                              validator: (value) =>
                                  Validator.validateEmail(email: value),
                              decoration: const InputDecoration(
                                labelText: "Email",
                                suffixIcon: Icon(Icons.mail_sharp),
                                //icon at head of input
                              )).paddingSymmetric(horizontal: 25),
                          TextFormField(
                                  controller: password,
                                  obscureText: visibility,
                                  validator: (value) =>
                                      Validator.validatePassword(password: value),
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              visibility = !visibility;
                                            });
                                          },
                                          icon: Icon(Icons.visibility))
                                      //icon at head of input
                                      ))
                              .paddingSymmetric(horizontal: 25),
                          SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.4,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      User? user = await FirebaseAuthHelper
                                          .registerUsingEmailPassword(
                                        name: name.text,
                                        email: email.text,
                                        password: password.text,
                                      );

                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (user != null) {
                                        await FirebaseAuthHelper.saveUserData(
                                          uid: user.uid,
                                          name: name.text,
                                          email: email.text,
                                          password: password.text,
                                          time: now.toString(),
                                        );
                                        //SharedPrefs().setUserName(name.text);
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                AppRouter.emailVerificationScreen);
                                      }
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Signup",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ))).paddingOnly(top: 40,bottom: 20),
                        ],
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 35),
                  Row(
                    children: [
                      const Text(
                        "I Have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ).paddingEnd(5),
                      RichText(
                        text: TextSpan(
                            text: "Login",
                            style: TextStyle(color: Colors.blue.shade700),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacementNamed(
                                    AppRouter.loginScreen);
                              }),
                      ),
                    ],
                  ).paddingOnly(top: 10, left: deviceSize.width * 0.28),
                  Visibility(
                    visible: _isLoading,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ).paddingTop(deviceSize.height * 0.2),
            ),
          ),
        ),
      ),
    );
  }
}
