import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/services/storage_service.dart';
import 'presentation/providers/providers.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  final storageService = StorageService();
  await storageService.init();

  runApp(const ProviderScope(child: StillAliveApp()));
}

class StillAliveApp extends StatelessWidget {
  const StillAliveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Still Alive',
      theme: AppTheme.lightTheme,
      home: const InitialRouteScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Screen that determines initial route based on onboarding status
class InitialRouteScreen extends ConsumerWidget {
  const InitialRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    // Check if onboarding is completed
    if (settings.onboardingCompleted) {
      return const MainNavigationScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
