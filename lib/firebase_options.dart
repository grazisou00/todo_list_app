
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions]
///

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
    apiKey: 'AIzaSyAsR6lwn3eJuCmrA-ExwXop0863S3zGNNI',
    appId: '1:424665707932:web:15d40fc883812ad8bc8459',
    messagingSenderId: '424665707932',
    projectId: 'to-do-list-app-7e10c',
    authDomain: 'to-do-list-app-7e10c.firebaseapp.com',
    storageBucket: 'to-do-list-app-7e10c.appspot.com',
    measurementId: 'G-C3NQZL1S92',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBDI2Z5MBtGX0JfGscPjBxw6mujehBGJMY',
    appId: '1:424665707932:android:00e2dc0b45308043bc8459',
    messagingSenderId: '424665707932',
    projectId: 'to-do-list-app-7e10c',
    storageBucket: 'to-do-list-app-7e10c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANrqkq_yuGCKn6L-hz3LAG_OtlEh5xcfw',
    appId: '1:424665707932:ios:6fad8fd6ec5714a2bc8459',
    messagingSenderId: '424665707932',
    projectId: 'to-do-list-app-7e10c',
    storageBucket: 'to-do-list-app-7e10c.appspot.com',
    iosBundleId: 'com.example.todoListApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyANrqkq_yuGCKn6L-hz3LAG_OtlEh5xcfw',
    appId: '1:424665707932:ios:6fad8fd6ec5714a2bc8459',
    messagingSenderId: '424665707932',
    projectId: 'to-do-list-app-7e10c',
    storageBucket: 'to-do-list-app-7e10c.appspot.com',
    iosBundleId: 'com.example.todoListApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAsR6lwn3eJuCmrA-ExwXop0863S3zGNNI',
    appId: '1:424665707932:web:26094f9761102e7bbc8459',
    messagingSenderId: '424665707932',
    projectId: 'to-do-list-app-7e10c',
    authDomain: 'to-do-list-app-7e10c.firebaseapp.com',
    storageBucket: 'to-do-list-app-7e10c.appspot.com',
    measurementId: 'G-LEVPX3RR7X',
  );

}