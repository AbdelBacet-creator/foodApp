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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5-Issd_69iddjl8qP0WCgPXO6QU1wvjE',
    appId: '1:486047923788:web:9188fcd877347299dcfee9',
    messagingSenderId: '486047923788',
    projectId: 'foodapp-b6411',
    authDomain: 'foodapp-b6411.firebaseapp.com',
    storageBucket: 'foodapp-b6411.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByDK0VrHfIVKk-gp_N1fx9l-75B-C6qj4',
    appId: '1:486047923788:android:76a72c72848f9250dcfee9',
    messagingSenderId: '486047923788',
    projectId: 'foodapp-b6411',
    storageBucket: 'foodapp-b6411.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5TzitKTIAxE3JV6asCISyv0y9XpwfDFs',
    appId: '1:486047923788:ios:c7fdd1d1fea76858dcfee9',
    messagingSenderId: '486047923788',
    projectId: 'foodapp-b6411',
    storageBucket: 'foodapp-b6411.appspot.com',
    iosClientId: '486047923788-j09pumfmh08hpgktrn5f0btdsb31vjcf.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodapp',
  );
}
