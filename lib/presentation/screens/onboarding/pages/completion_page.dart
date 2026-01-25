import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Completion page - final page of onboarding
class CompletionPage extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback? onSendTestSMS;

  const CompletionPage({
    super.key,
    required this.onComplete,
    this.onSendTestSMS,
  });

  @override
  State<CompletionPage> createState() => _CompletionPageState();
}

class _CompletionPageState extends State<CompletionPage> {
  bool _testSMSSent = false;

  void _handleSendTestSMS() {
    widget.onSendTestSMS?.call();
    setState(() {
      _testSMSSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 120, color: Colors.green),
          const SizedBox(height: 32),
          Text(
            'You\'re All Set!',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Your daily check-in system is ready to go',
            style: AppTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'What Happens Next',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoItem(
                  number: '1',
                  title: 'Daily Check-in Window',
                  description:
                      'Check in during your window to confirm you\'re okay',
                ),
                const SizedBox(height: 12),
                _InfoItem(
                  number: '2',
                  title: 'Reminders',
                  description:
                      'Get notifications when your window opens and before it closes',
                ),
                const SizedBox(height: 12),
                _InfoItem(
                  number: '3',
                  title: 'Emergency Alerts',
                  description:
                      'If you miss a check-in, we\'ll alert your contacts',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (widget.onSendTestSMS != null) ...[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _testSMSSent ? null : _handleSendTestSMS,
                icon: Icon(_testSMSSent ? Icons.check : Icons.sms),
                label: Text(
                  _testSMSSent ? 'Test SMS Sent' : 'Send Test SMS (Optional)',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.onComplete,
              child: const Text('Get Started'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You can change these settings anytime',
            style: AppTheme.bodySmall.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _InfoItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
