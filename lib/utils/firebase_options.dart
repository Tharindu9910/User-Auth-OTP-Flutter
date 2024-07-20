// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCc6bpzaQyYKKo00773Xxkui8YXKeXD20s',
    appId: '1:251704771304:android:4216f6d9c1916fe44aff5d',
    messagingSenderId: '251704771304',
    projectId: 'userauth-8e01a',
    databaseURL: 'https://userauth-8e01a-default-rtdb.firebaseio.com',
    storageBucket: 'userauth-8e01a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_jhHRjCjY4_pnVpjuwXC7-ZfsE_RMxrg',
    appId: '1:251704771304:ios:4816965d57a2be0c4aff5d',
    messagingSenderId: '251704771304',
    projectId: 'userauth-8e01a',
    databaseURL: 'https://userauth-8e01a-default-rtdb.firebaseio.com',
    storageBucket: 'userauth-8e01a.appspot.com',
    iosClientId: '251704771304-n6s6ucoknpa0a8cqmhe7qla0e39i8d7p.apps.googleusercontent.com',
    iosBundleId: 'com.example.userAuth',
  );
}