import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Emergency alert button
class EmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDisabled;
  final String? disabledReason;

  const EmergencyButton({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
    this.disabledReason,
  });

  Future<void> _handlePress(BuildContext context) async {
    if (isDisabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(disabledReason ?? 'Emergency button is disabled'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Alert'),
          ],
        ),
        content: const Text(
          'This will immediately send emergency alerts to all your contacts.\n\n'
          'SMS messages and phone calls will be sent.\n\n'
          'Only use this button in a real emergency.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: isDisabled
            ? () => _handlePress(context)
            : () => _handlePress(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey : Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.warning, size: 28),
        label: Text(
          'Emergency Alert',
          style: AppTheme.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
