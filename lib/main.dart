import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive storage
  final storageService = StorageService();
  await storageService.init();

  runApp(
    const ProviderScope(
      child: StillAliveApp(),
    ),
  );
}

class StillAliveApp extends StatelessWidget {
  const StillAliveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Still Alive',
      theme: AppTheme.lightTheme,
      home: const PlaceholderScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Placeholder screen for Phase 1
/// Will be replaced with proper onboarding/home screen in Phase 2
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Still Alive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Still Alive',
              style: AppTheme.headlineLarge.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Phase 1: Foundation Complete ✓',
                style: AppTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Data models, repositories, and storage initialized',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
