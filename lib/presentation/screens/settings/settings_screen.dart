import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'widgets/time_window_setting.dart';
import 'widgets/notification_settings.dart';
import 'widgets/permission_status_card.dart';
import 'widgets/about_section.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Check-in Window
          TimeWindowSetting(
            settings: settings,
            onUpdate: (start, end) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .updateCheckinWindow(start: start, end: end);

              // Refresh checkin state to reflect new window
              ref.read(checkinNotifierProvider.notifier).refresh();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check-in window updated'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Notification Settings
          NotificationSettings(
            settings: settings,
            onToggleNotifications: (enabled) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleNotifications(enabled);
            },
            onToggleReminderBeforeWindow: (enabled) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderBeforeWindow(enabled);
            },
            onToggleReminderAtWindowStart: (enabled) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderAtWindowStart(enabled);
            },
            onToggleReminderBeforeDeadline: (enabled) async {
              await ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderBeforeDeadline(enabled);
            },
          ),
          const SizedBox(height: 16),

          // Permission Status
          const PermissionStatusCard(),
          const SizedBox(height: 16),

          // About Section
          const AboutSection(),
          const SizedBox(height: 16),

          // Reset/Debug Section (for development)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report, color: Colors.orange),
                  title: const Text('Developer Options'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Reset Onboarding'),
                  subtitle: const Text('Go through setup again'),
                  trailing: const Icon(Icons.refresh),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Onboarding'),
                        content: const Text(
                          'This will mark onboarding as incomplete. '
                          'You\'ll go through the setup process again on next app start.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref
                          .read(settingsRepositoryProvider)
                          .updateSettings(onboardingCompleted: false);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Onboarding reset. Restart app to see changes.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
