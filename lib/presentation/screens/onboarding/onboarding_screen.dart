import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'pages/welcome_page.dart';
import 'pages/permissions_page.dart';
import 'pages/time_window_page.dart';
import 'pages/contacts_page.dart';
import 'pages/completion_page.dart';
import 'widgets/onboarding_page_indicator.dart';

/// Main onboarding screen with page view
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  // State for time window
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleTimeWindowContinue(TimeOfDay start, TimeOfDay end) {
    setState(() {
      _startTime = start;
      _endTime = end;
    });
    _nextPage();
  }

  Future<void> _completeOnboarding() async {
    // Save time window settings
    await ref
        .read(settingsNotifierProvider.notifier)
        .updateCheckinWindow(start: _startTime, end: _endTime);

    // Mark onboarding as completed
    await ref.read(settingsNotifierProvider.notifier).completeOnboarding();

    // Navigation will automatically happen via InitialRouteScreen
  }

  void _sendTestSMS() {
    // TODO: Implement test SMS in Phase 3
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test SMS will be implemented in Phase 3')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPage > 0
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              ),
              title: Text('Step ${_currentPage + 1} of $_totalPages'),
              centerTitle: true,
              actions: [
                if (_currentPage < _totalPages - 1)
                  TextButton(onPressed: _nextPage, child: const Text('Skip')),
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage > 0) ...[
              const SizedBox(height: 16),
              OnboardingPageIndicator(
                currentPage: _currentPage,
                totalPages: _totalPages,
              ),
            ],
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WelcomePage(onGetStarted: _nextPage),
                  PermissionsPage(onContinue: _nextPage),
                  TimeWindowPage(
                    initialStart: _startTime,
                    initialEnd: _endTime,
                    onContinue: _handleTimeWindowContinue,
                  ),
                  ContactsPage(onContinue: _nextPage),
                  CompletionPage(
                    onComplete: _completeOnboarding,
                    onSendTestSMS: _sendTestSMS,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
