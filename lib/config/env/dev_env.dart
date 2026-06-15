import 'package:bazaar/config/env/env.dart';

class DevEnv implements Env {
  const DevEnv();

  @override
  String get appName => 'Bazaar';

  @override
  bool get isProduction => false;
}
