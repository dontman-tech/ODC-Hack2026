import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY', defaultValue: 'REPLACE_WITH_ANDROID_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: 'REPLACE_WITH_ANDROID_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'REPLACE_WITH_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'REPLACE_WITH_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'REPLACE_WITH_STORAGE_BUCKET'),
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: 'REPLACE_WITH_IOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: 'REPLACE_WITH_IOS_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'REPLACE_WITH_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 'REPLACE_WITH_PROJECT_ID'),
    iosBundleId: 'ai.arena.rekollect',
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 'REPLACE_WITH_STORAGE_BUCKET'),
  );
}
