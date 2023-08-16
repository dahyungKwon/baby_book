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
    apiKey: 'AIzaSyC1IgDwP2nw5Eb0AAANT1uIRXOKMAaWppg',
    appId: '1:1081779194095:web:57bc42e584a91ec099b31a',
    messagingSenderId: '1081779194095',
    projectId: 'babybear-readbook',
    authDomain: 'babybear-readbook.firebaseapp.com',
    storageBucket: 'babybear-readbook.appspot.com',
    measurementId: 'G-Z753WZ91WY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnZ_N50g0iF8pAiKNcSY049d8rrQTHE-c',
    appId: '1:1081779194095:android:b4ef05a7c25bdc9c99b31a',
    messagingSenderId: '1081779194095',
    projectId: 'babybear-readbook',
    storageBucket: 'babybear-readbook.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC60FKZlz0rZTkrskDmfXQlcgE8Llk2wQY',
    appId: '1:1081779194095:ios:f1476caf7d18a0fe99b31a',
    messagingSenderId: '1081779194095',
    projectId: 'babybear-readbook',
    storageBucket: 'babybear-readbook.appspot.com',
    iosClientId: '1081779194095-linunb7mms27la2m2t86b1iklld7038s.apps.googleusercontent.com',
    iosBundleId: 'com.babybear.readbook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC60FKZlz0rZTkrskDmfXQlcgE8Llk2wQY',
    appId: '1:1081779194095:ios:f1476caf7d18a0fe99b31a',
    messagingSenderId: '1081779194095',
    projectId: 'babybear-readbook',
    storageBucket: 'babybear-readbook.appspot.com',
    iosClientId: '1081779194095-linunb7mms27la2m2t86b1iklld7038s.apps.googleusercontent.com',
    iosBundleId: 'com.babybear.readbook',
  );
}
