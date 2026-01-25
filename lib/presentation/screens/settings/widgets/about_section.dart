import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// About section showing app information
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info, color: AppTheme.primaryColor),
            title: const Text('About'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('App Version'),
            trailing: const Text('1.0.0'),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Privacy Policy'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'Still Alive Privacy Policy\n\n'
                      'All data is stored locally on your device:\n'
                      '• Emergency contacts\n'
                      '• Check-in history\n'
                      '• App settings\n\n'
                      'We do not:\n'
                      '• Collect any personal data\n'
                      '• Send data to external servers\n'
                      '• Track your usage\n\n'
                      'SMS and phone calls are only sent to your designated '
                      'emergency contacts when you miss a check-in or trigger '
                      'a manual alert.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('How It Works'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How It Works'),
                  content: const SingleChildScrollView(
                    child: Text(
                      '1. Set Your Window\n'
                      'Choose a daily time window when you\'ll check in.\n\n'
                      '2. Daily Check-In\n'
                      'During your window, tap the check-in button.\n\n'
                      '3. Reminders\n'
                      'Get notifications to remind you to check in.\n\n'
                      '4. Emergency Alerts\n'
                      'If you miss a check-in, your contacts are alerted '
                      'via SMS and phone calls.\n\n'
                      '5. Manual Alerts\n'
                      'Use the emergency button to immediately alert contacts.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
