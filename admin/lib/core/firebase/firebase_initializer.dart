import 'package:admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
