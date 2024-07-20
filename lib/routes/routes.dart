import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/screens/otp_screen.dart';
import 'package:user_auth/screens/profile_screen.dart';
import 'package:user_auth/screens/signup_screen.dart';
import 'package:user_auth/screens/phone_signin_screen.dart';

import '../screens/email_verification_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AppRouter {
  static const loginScreen = "/loginScreen",
      signUpScreen = "/signUpScreen",
      profile = "/profile",
      phoneSignIn = "/phoneSignIn",
      otpScreen = "/otpScreen",
      emailVerificationScreen = "/emailVerificationScreen",
      homeScreen = "/homeScreen";

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case phoneSignIn:
        return MaterialPageRoute(
          builder: (BuildContext context) => const PhoneSignInScreen(),
        );
      case signUpScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      // case otpScreen:
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) => const OtpScreen(verificationId: verificationId),
      //   );
      case emailVerificationScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const EmailVerificationScreen(),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
      case profile:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileScreen(),
        );


      default:
        return null;
    }
  }
}
