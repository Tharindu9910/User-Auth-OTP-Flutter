import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/padding_extensions.dart';

import '../utils/firebase_constants.dart';
import '../utils/hex_color.dart';
import 'otp_screen.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({Key? key}) : super(key: key);



  @override
  State<PhoneSignInScreen> createState() => _PhoneSigninScreenState();
}

class _PhoneSigninScreenState extends State<PhoneSignInScreen> {
  bool _isLoading = false;
  bool visibility = false;
  bool codeSent = false;

  final TextEditingController _phoneController = TextEditingController();
  String verificationId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOTP() async {
    final phone = _phoneController.text.trim();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
            ));
        // Navigator.of(context).pushReplacementNamed(AppRouter.otpScreen);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(
            "Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          this.codeSent = true;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                  verificationId: this.verificationId,
                )));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: deviceSize.height*0.25,
                height: deviceSize.height*0.25,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.phone,size: deviceSize.height*0.13)
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Add your phone number. we'll send you a verification code",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#FFFFFF"),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        labelText: "PhoneNumber",
                        // prefix: const Text(
                        //   '(+94)',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ).paddingSymmetric(horizontal: 8),
                        suffixIcon: Icon(
                          Icons.check_circle,
                          size: 20,
                        ),
                      ),
                    ).paddingOnly(top: 10,left: 25,right: 25),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           sendOTP();

                          //Navigator.of(context).pushNamed(AppRouter.otpScreen);
                        },
                        child: const Text(
                          'Send',
                          style: TextStyle(fontSize: 16),
                        ).paddingAll(14),
                      ).paddingOnly(bottom: 20,left: 25,right: 25),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ).paddingSymmetric(vertical: 24, horizontal: 32),
    );
  }
}
