// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:still_alive/main.dart';

void main() {
  testWidgets('App launches and shows onboarding', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const ProviderScope(child: StillAliveApp()));
    await tester.pumpAndSettle();

    // Verify that the onboarding welcome page is displayed
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Daily check-ins to let your loved ones know you\'re okay'), findsOneWidget);
  });
}
