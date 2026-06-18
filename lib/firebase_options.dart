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
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY', defaultValue: 'AIzaSyCa5M7iniZIL7uG0lUNieTdoLo2UlDZd88'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID', defaultValue: '1:431621574250:android:b07811fe4a056552b38413'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'R431621574250'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 're-kollect-f5c4e'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 're-kollect-f5c4e.firebasestorage.app'),
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: 'AIzaSyDZZk15rVTIIzHFhp9TkcJYVEGkxp9yuNY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: '1:431621574250:ios:5b6254d2df46b73eb38413'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: 'R431621574250'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: 're-kollect-f5c4e'),
    iosBundleId: 'ai.arena.rekollect',
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: 're-kollect-f5c4e.firebasestorage.app'),
  );
}
