import 'package:bazaar/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash page renders Bazaar branding', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashPage()),
    );

    expect(find.text('Bazaar'), findsOneWidget);
  });
}
