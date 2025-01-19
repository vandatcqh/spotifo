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
        return web;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOption  s are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAC8mmhkBnDhi78DASc_-nfK_jjpBfL8ME',
    appId: '1:315311514431:web:fe80d6880ea323825a698a',
    messagingSenderId: '315311514431',
    projectId: 'spotifo-ded50',
    authDomain: 'spotifo-ded50.firebaseapp.com',
    storageBucket: 'spotifo-ded50.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHh5Dd3I2D83lifp00bF4dEkqnQKlm8Yo',
    appId: '1:315311514431:android:73685ce5626893645a698a',
    messagingSenderId: '315311514431',
    projectId: 'spotifo-ded50',
    storageBucket: 'spotifo-ded50.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8Yiia7CWiBr2LJjf48F97_92PtttE8m0',
    appId: '1:315311514431:ios:b80d49527dc40f305a698a',
    messagingSenderId: '315311514431',
    projectId: 'spotifo-ded50',
    storageBucket: 'spotifo-ded50.firebasestorage.app',
    iosBundleId: 'com.example.spotifo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8Yiia7CWiBr2LJjf48F97_92PtttE8m0',
    appId: '1:315311514431:ios:b80d49527dc40f305a698a',
    messagingSenderId: '315311514431',
    projectId: 'spotifo-ded50',
    storageBucket: 'spotifo-ded50.firebasestorage.app',
    iosBundleId: 'com.example.spotifo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAC8mmhkBnDhi78DASc_-nfK_jjpBfL8ME',
    appId: '1:315311514431:web:66cd20afd14ce7815a698a',
    messagingSenderId: '315311514431',
    projectId: 'spotifo-ded50',
    authDomain: 'spotifo-ded50.firebaseapp.com',
    storageBucket: 'spotifo-ded50.firebasestorage.app',
  );
}
