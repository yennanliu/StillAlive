import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Warning banner shown when user has less than 2 contacts
class MinimumContactsWarning extends StatelessWidget {
  final int currentCount;

  const MinimumContactsWarning({super.key, required this.currentCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minimum contacts required',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You need at least 2 emergency contacts. Current: $currentCount',
                  style: AppTheme.bodySmall.copyWith(color: Colors.red[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
