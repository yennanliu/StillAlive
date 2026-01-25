import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Welcome page - first page of onboarding
class WelcomePage extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomePage({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 120, color: AppTheme.primaryColor),
          const SizedBox(height: 32),
          Text(
            'Welcome to\nStill Alive',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Daily check-ins to let your loved ones know you\'re okay',
            style: AppTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Set a daily time window to check in. If you miss it, we\'ll alert your emergency contacts.',
              style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          const _FeatureItem(
            icon: Icons.notifications_active,
            title: 'Daily Reminders',
            description: 'Get notified during your check-in window',
          ),
          const SizedBox(height: 16),
          const _FeatureItem(
            icon: Icons.people,
            title: 'Emergency Contacts',
            description: 'Add 2-5 people to be alerted if needed',
          ),
          const SizedBox(height: 16),
          const _FeatureItem(
            icon: Icons.privacy_tip,
            title: 'Privacy First',
            description: 'All data stored locally on your device',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onGetStarted,
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
