// File generated for Firebase configuration
// Project: Biblia Chat Cristiano

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAjGfsNtboLQSuH-xX3n2vNoF5mni9KRFQ',
    appId: '1:585975354122:android:203c5e92e9c71b2ceda0f3',
    messagingSenderId: '585975354122',
    projectId: 'biblia-chat-cristiano',
    storageBucket: 'biblia-chat-cristiano.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqcFIMQ3hjLqylgC6KkxMbk9MjZe4etuk',
    appId: '1:585975354122:ios:2352c0e638f7d33ceda0f3',
    messagingSenderId: '585975354122',
    projectId: 'biblia-chat-cristiano',
    storageBucket: 'biblia-chat-cristiano.firebasestorage.app',
    iosBundleId: 'ee.bikain.bibliachat',
  );
}
