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
        return windows;
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
    apiKey: 'AIzaSyCceSS9T0vhuMoZEHufKOk8U_oDz8Fg0o0',
    appId: '1:669558761572:web:2b58ceb227d584279a1771',
    messagingSenderId: '669558761572',
    projectId: 'missme-a318f',
    authDomain: 'missme-a318f.firebaseapp.com',
    storageBucket: 'missme-a318f.appspot.com',
    measurementId: 'G-EX84ML5Q76',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTh5c2Mk5TUuKDvG81m71lX0SR7WScsn4',
    appId: '1:669558761572:android:6728497c5a6f09b99a1771',
    messagingSenderId: '669558761572',
    projectId: 'missme-a318f',
    storageBucket: 'missme-a318f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBP3LEvsEjS9j7ipd5Yn2H_1MCW3qRol1M',
    appId: '1:669558761572:ios:615a2854dfb0abda9a1771',
    messagingSenderId: '669558761572',
    projectId: 'missme-a318f',
    storageBucket: 'missme-a318f.appspot.com',
    iosClientId: '669558761572-25lkmnlqpccj6cqotpihaig6eh9hp6nm.apps.googleusercontent.com',
    iosBundleId: 'com.example.task',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBP3LEvsEjS9j7ipd5Yn2H_1MCW3qRol1M',
    appId: '1:669558761572:ios:615a2854dfb0abda9a1771',
    messagingSenderId: '669558761572',
    projectId: 'missme-a318f',
    storageBucket: 'missme-a318f.appspot.com',
    iosClientId: '669558761572-25lkmnlqpccj6cqotpihaig6eh9hp6nm.apps.googleusercontent.com',
    iosBundleId: 'com.example.task',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCceSS9T0vhuMoZEHufKOk8U_oDz8Fg0o0',
    appId: '1:669558761572:web:acac6ad8ded4fc479a1771',
    messagingSenderId: '669558761572',
    projectId: 'missme-a318f',
    authDomain: 'missme-a318f.firebaseapp.com',
    storageBucket: 'missme-a318f.appspot.com',
    measurementId: 'G-YQ3BZ0NE2G',
  );
}
