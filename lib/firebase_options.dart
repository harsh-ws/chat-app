// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAunGYDqLju1TcqePwUGEgj2iJI2yD0F_0',
    appId: '1:1005377356687:web:698cccdfeda211c2ad01fa',
    messagingSenderId: '1005377356687',
    projectId: 'superchat-bedf2',
    authDomain: 'superchat-bedf2.firebaseapp.com',
    storageBucket: 'superchat-bedf2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0NB_Kr0KbLv0x-kPWRq0s8ckA4KS62Mo',
    appId: '1:1005377356687:android:089f7a977083ab57ad01fa',
    messagingSenderId: '1005377356687',
    projectId: 'superchat-bedf2',
    storageBucket: 'superchat-bedf2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSrR3bZS0Z2245-cniDtL4SWyF1xTzOxk',
    appId: '1:1005377356687:ios:eea0f11fdac4fa41ad01fa',
    messagingSenderId: '1005377356687',
    projectId: 'superchat-bedf2',
    storageBucket: 'superchat-bedf2.appspot.com',
    iosClientId: '1005377356687-gm1sdp3b2f74dnbsacmq1s9k4o7f85cu.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCSrR3bZS0Z2245-cniDtL4SWyF1xTzOxk',
    appId: '1:1005377356687:ios:eea0f11fdac4fa41ad01fa',
    messagingSenderId: '1005377356687',
    projectId: 'superchat-bedf2',
    storageBucket: 'superchat-bedf2.appspot.com',
    iosClientId: '1005377356687-gm1sdp3b2f74dnbsacmq1s9k4o7f85cu.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterChat',
  );
}
