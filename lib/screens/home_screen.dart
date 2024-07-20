import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/padding_extensions.dart';

import '../models/google_auth.dart';
import '../utils/sharedpref_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), toolbarHeight: 80, actions: [
        IconButton(
          icon: const Icon(Icons.person_2_rounded),
          tooltip: 'User Profile',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRouter.profile);
          },
        ),
      ]),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  AuthenticationProvider().signOut(context);
                  if (mounted) {
                    await FirebaseAuth.instance.signOut();
                    SharedPrefs().clearAll();
                    Navigator.of(context).pushReplacementNamed(
                      AppRouter.loginScreen,
                    );
                  }
                },
                child: const Text(
                  "LogOut",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ))
          ],
        ).paddingTop(deviceSize.height*0.7),
      ),
    );
  }
}
