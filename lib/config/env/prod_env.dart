import 'package:bazaar/config/env/env.dart';

class ProdEnv implements Env {
  const ProdEnv();

  @override
  String get appName => 'Bazaar';

  @override
  bool get isProduction => true;
}
