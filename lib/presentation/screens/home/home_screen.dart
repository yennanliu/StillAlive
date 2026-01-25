import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'widgets/checkin_button.dart';
import 'widgets/status_indicator.dart';
import 'widgets/countdown_timer.dart';
import 'widgets/pause_toggle.dart';
import 'widgets/emergency_button.dart';
import 'widgets/today_summary_card.dart';

/// Home screen - main check-in interface
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh every minute to update countdown timer
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      ref.read(checkinNotifierProvider.notifier).refresh();
      ref.read(homeNotifierProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCheckin() async {
    try {
      await ref.read(checkinNotifierProvider.notifier).completeCheckin();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Check-in complete! Great job!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the home state
      ref.read(homeNotifierProvider.notifier).refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleEmergencyAlert() async {
    try {
      await ref.read(checkinNotifierProvider.notifier).triggerManualAlert();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Emergency alert triggered. Contacts will be notified.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }

      // Refresh the home state
      ref.read(homeNotifierProvider.notifier).refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handlePauseToggle(bool shouldPause) async {
    try {
      if (shouldPause) {
        await ref.read(settingsNotifierProvider.notifier).pauseCheckins();
      } else {
        await ref.read(settingsNotifierProvider.notifier).resumeCheckins();
      }

      // Refresh all notifiers
      ref.read(checkinNotifierProvider.notifier).refresh();
      ref.read(homeNotifierProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              shouldPause ? 'Check-ins paused' : 'Check-ins resumed',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Still Alive'), centerTitle: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.read(checkinNotifierProvider.notifier).refresh();
            ref.read(homeNotifierProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Status Indicator
                  Center(
                    child: StatusIndicator(status: homeState.currentStatus),
                  ),
                  const SizedBox(height: 32),

                  // Check-in Button
                  Center(
                    child: CheckinButton(
                      status: homeState.currentStatus,
                      onPressed: _handleCheckin,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Countdown Timer (only shown when window is active)
                  if (homeState.timeRemaining != null) ...[
                    Center(
                      child: CountdownTimer(
                        timeRemaining: homeState.timeRemaining,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Today Summary Card
                  TodaySummaryCard(
                    todayRecord: homeState.todayRecord,
                    settings: settings,
                    currentStreak: homeState.currentStreak,
                  ),
                  const SizedBox(height: 16),

                  // Pause Toggle
                  PauseToggle(
                    isPaused: homeState.isPaused,
                    pausedSince: homeState.pausedSince,
                    onToggle: _handlePauseToggle,
                  ),
                  const SizedBox(height: 24),

                  // Emergency Button
                  EmergencyButton(
                    onPressed: _handleEmergencyAlert,
                    isDisabled: !homeState.hasMinimumContacts,
                    disabledReason:
                        'Add at least 2 emergency contacts to use this feature',
                  ),
                  const SizedBox(height: 16),

                  // Contact count info
                  if (!homeState.hasMinimumContacts)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You have ${homeState.contactCount} contact${homeState.contactCount != 1 ? 's' : ''}. '
                              'Add at least 2 to enable emergency alerts.',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
