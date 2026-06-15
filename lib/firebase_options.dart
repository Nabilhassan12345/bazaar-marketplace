// File generated for Bazaar marketplace — project: bazaar-dev-e4d92
// Re-run `flutterfire configure --project=bazaar-dev-e4d92` to refresh.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCXP59PLf4ynrt3iEaEaM41t0Vd5a1aHpw',
    appId: '1:495058275787:web:15a1cdcda4f55ae9337a4e',
    messagingSenderId: '495058275787',
    projectId: 'bazaar-dev-e4d92',
    authDomain: 'bazaar-dev-e4d92.firebaseapp.com',
    storageBucket: 'bazaar-dev-e4d92.firebasestorage.app',
    measurementId: 'G-C0TW8N4YTV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLVl0Q6-LhOEBrA-ahRQ4_ejwXPIZz_Q8',
    appId: '1:495058275787:android:70d00e13eed804a6337a4e',
    messagingSenderId: '495058275787',
    projectId: 'bazaar-dev-e4d92',
    storageBucket: 'bazaar-dev-e4d92.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZuHyj6H8g4q0S32gcS-zysL0RBdUdu8M',
    appId: '1:495058275787:ios:e39abd9d3d5f21e7337a4e',
    messagingSenderId: '495058275787',
    projectId: 'bazaar-dev-e4d92',
    storageBucket: 'bazaar-dev-e4d92.firebasestorage.app',
    iosBundleId: 'com.bazaar.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZuHyj6H8g4q0S32gcS-zysL0RBdUdu8M',
    appId: '1:495058275787:ios:4d44621e13dd3af4337a4e',
    messagingSenderId: '495058275787',
    projectId: 'bazaar-dev-e4d92',
    storageBucket: 'bazaar-dev-e4d92.firebasestorage.app',
    iosBundleId: 'com.bazaar.app',
  );
}
