import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/padding_extensions.dart';

import '../utils/firebase_constants.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  OtpScreen({required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String _otp;
  //String _verificationId = widget.verificationId;
  void verifyOTP() async {
    final otp = _otp.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    await auth.signInWithCredential(credential).then((UserCredential result) {
      Navigator.of(context).pushNamed(AppRouter.homeScreen);
    }).catchError((e) {
      print("Error: ${e}");
    });
  }
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                child:Icon(Icons.password_rounded,size: deviceSize.height*0.13)
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 20),
                        Flexible(
                          child: SizedBox(
                            height: deviceSize.height*0.09,
                            width:deviceSize.width*0.9,
                            child: OtpTextField(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                numberOfFields: 6,
                                fieldWidth: 35,
                                fillColor: Colors.black.withOpacity(0.08),
                                filled: true,
                                onSubmit: (code) {
                                  setState(() {
                                    _otp = code;
                                  });
                                  print("OTP is => $code");
                                }
                          ).paddingEnd(10),
                        ),

                        // _textFieldOTP(first: true, last: false),
                        // _textFieldOTP(first: false, last: false),
                        // _textFieldOTP(first: false, last: false),
                        // _textFieldOTP(first: false, last: true),
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: deviceSize.width*0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          print(_otp);
                          verifyOTP();
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ).paddingAll(14),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Resend New Code",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      height: 55,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextFormField(
          controller: _otpController,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.amber),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}