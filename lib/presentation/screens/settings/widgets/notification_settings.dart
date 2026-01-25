import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_settings.dart';

/// Widget for managing notification settings
class NotificationSettings extends StatelessWidget {
  final UserSettings settings;
  final Function(bool) onToggleNotifications;
  final Function(bool) onToggleReminderBeforeWindow;
  final Function(bool) onToggleReminderAtWindowStart;
  final Function(bool) onToggleReminderBeforeDeadline;
  final bool permissionGranted;

  const NotificationSettings({
    super.key,
    required this.settings,
    required this.onToggleNotifications,
    required this.onToggleReminderBeforeWindow,
    required this.onToggleReminderAtWindowStart,
    required this.onToggleReminderBeforeDeadline,
    this.permissionGranted = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: AppTheme.primaryColor),
            title: const Text('Notifications'),
            subtitle: Text(
              permissionGranted
                  ? 'Configure your reminders'
                  : 'Permission required',
            ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Master toggle for all notifications'),
            value: settings.notificationsEnabled,
            onChanged: permissionGranted ? onToggleNotifications : null,
          ),
          if (settings.notificationsEnabled) ...[
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('30 Minutes Before Window'),
              subtitle: const Text('Reminder that your window opens soon'),
              value: settings.reminderBeforeWindow,
              onChanged: permissionGranted
                  ? onToggleReminderBeforeWindow
                  : null,
              secondary: const Icon(Icons.notification_important),
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('At Window Start'),
              subtitle: const Text('Reminder when your window opens'),
              value: settings.reminderAtWindowStart,
              onChanged: permissionGranted
                  ? onToggleReminderAtWindowStart
                  : null,
              secondary: const Icon(Icons.alarm),
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('15 Minutes Before Deadline'),
              subtitle: const Text('Urgent reminder before window closes'),
              value: settings.reminderBeforeDeadline,
              onChanged: permissionGranted
                  ? onToggleReminderBeforeDeadline
                  : null,
              secondary: const Icon(Icons.warning),
            ),
          ],
        ],
      ),
    );
  }
}
