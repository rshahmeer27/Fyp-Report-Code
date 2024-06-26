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
    apiKey: 'AIzaSyAsj6hRx2z5T6u5t9tEqxU6FAgtqquU_EY',
    appId: '1:33846486285:web:a48b3be5e8cec2e93d7c44',
    messagingSenderId: '33846486285',
    projectId: 'simplypoem-fc7cd',
    authDomain: 'simplypoem-fc7cd.firebaseapp.com',
    storageBucket: 'simplypoem-fc7cd.appspot.com',
    measurementId: 'G-1PH4FDHHHX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyUvHGORz319nFOjvHWKwcwHUk3E-z5bg',
    appId: '1:571343756037:android:61b77942ca379ad1d5b56c',
    messagingSenderId: '571343756037',
    projectId: 'skoop-e9628',
    storageBucket: 'skoop-e9628.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8Kwha-fKNUKBc9bXDKe9hd_sa-lP3j4A',
    appId: '1:33846486285:ios:061d25e492f115a23d7c44',
    messagingSenderId: '33846486285',
    projectId: 'skoop-31ac0',
    storageBucket: 'simplypoem-fc7cd.appspot.com',
    iosClientId:
        '33846486285-a196pl84rrruet5k5mojlag6nrttda2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.simplyPoem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8Kwha-fKNUKBc9bXDKe9hd_sa-lP3j4A',
    appId: '1:33846486285:ios:061d25e492f115a23d7c44',
    messagingSenderId: '33846486285',
    projectId: 'simplypoem-fc7cd',
    storageBucket: 'simplypoem-fc7cd.appspot.com',
    iosClientId:
        '33846486285-a196pl84rrruet5k5mojlag6nrttda2u.apps.googleusercontent.com',
    iosBundleId: 'com.example.simplyPoem',
  );
}
