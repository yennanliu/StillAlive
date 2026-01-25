// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:still_alive/main.dart';
import 'package:still_alive/data/models/checkin_record.dart';
import 'package:still_alive/data/models/checkin_status.dart';
import 'package:still_alive/data/models/emergency_contact.dart';
import 'package:still_alive/data/models/user_settings.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing with temporary directory
    TestWidgetsFlutterBinding.ensureInitialized();

    final tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);

    // Register type adapters
    Hive.registerAdapter(CheckinStatusAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(EmergencyContactAdapter());
    Hive.registerAdapter(CheckinRecordAdapter());

    // Open boxes
    await Hive.openBox<UserSettings>('settings_box');
    await Hive.openBox<EmergencyContact>('contacts_box');
    await Hive.openBox<CheckinRecord>('checkin_box');
  });

  testWidgets('App launches and shows onboarding', (WidgetTester tester) async {
    // Set larger screen size to avoid layout overflow
    await tester.binding.setSurfaceSize(const Size(1080, 2400));

    // Build our app and trigger a frame
    await tester.pumpWidget(const ProviderScope(child: StillAliveApp()));
    await tester.pump();

    // Verify that the onboarding welcome page is displayed
    expect(find.text('Get Started'), findsOneWidget);
    expect(
      find.text('Daily check-ins to let your loved ones know you\'re okay'),
      findsOneWidget,
    );

    // Reset screen size
    await tester.binding.setSurfaceSize(null);
  });
}
