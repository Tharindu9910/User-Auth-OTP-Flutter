import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_auth/screens/login_screen.dart';
import 'package:user_auth/routes/routes.dart';
import 'package:user_auth/utils/theme_data.dart';
import 'package:user_auth/utils/sharedpref_utils.dart';
import 'package:provider/provider.dart';
import 'utils/firebase_options.dart';
import 'models/google_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //initializing firebase
  SharedPrefs().init(); //initializing shared preferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>AuthenticationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: GlobalThemData.lightThemeData,
        darkTheme: GlobalThemData.darkThemeData,
        home: LoginScreen(),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}

