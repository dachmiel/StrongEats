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
    apiKey: 'AIzaSyB_YrhOEqiIR9MlDRPMvOPHE8Z0C7K_cRM',
    appId: '1:621979015912:web:a5e6d2e64e2b009633075d',
    messagingSenderId: '621979015912',
    projectId: 'strongeats-1bb50',
    authDomain: 'strongeats-1bb50.firebaseapp.com',
    storageBucket: 'strongeats-1bb50.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCR_D7zQjXzXDmiWsI-OKh2FfLG7nsP3zY',
    appId: '1:621979015912:android:1fbf547092e9f56833075d',
    messagingSenderId: '621979015912',
    projectId: 'strongeats-1bb50',
    storageBucket: 'strongeats-1bb50.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjJPwkkWpZXkVBCm6NkrsXxpp_j2Z17Yg',
    appId: '1:621979015912:ios:d2cce781a48bbcc733075d',
    messagingSenderId: '621979015912',
    projectId: 'strongeats-1bb50',
    storageBucket: 'strongeats-1bb50.appspot.com',
    iosClientId: '621979015912-iaar7dajgps62arssdvtov5slfl90ipf.apps.googleusercontent.com',
    iosBundleId: 'com.strongeats.strongeats',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjJPwkkWpZXkVBCm6NkrsXxpp_j2Z17Yg',
    appId: '1:621979015912:ios:f80d8a7ccd8e0be033075d',
    messagingSenderId: '621979015912',
    projectId: 'strongeats-1bb50',
    storageBucket: 'strongeats-1bb50.appspot.com',
    iosClientId: '621979015912-3587kr9b7jqbuqvr7pvfrpurkitfpjd5.apps.googleusercontent.com',
    iosBundleId: 'com.strongeats.strongeats.RunnerTests',
  );
}
