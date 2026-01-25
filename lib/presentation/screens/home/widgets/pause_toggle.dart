import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// Toggle switch for pausing/resuming check-ins
class PauseToggle extends StatelessWidget {
  final bool isPaused;
  final DateTime? pausedSince;
  final Function(bool) onToggle;

  const PauseToggle({
    super.key,
    required this.isPaused,
    this.pausedSince,
    required this.onToggle,
  });

  Future<void> _handleToggle(BuildContext context) async {
    if (!isPaused) {
      // Pausing - show confirmation
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pause Check-Ins'),
          content: const Text(
            'Are you sure you want to pause daily check-ins?\n\n'
            'Emergency contacts will NOT be alerted if you don\'t check in.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
              ),
              child: const Text('Pause'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        onToggle(true);
      }
    } else {
      // Resuming - no confirmation needed
      onToggle(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPaused ? Icons.pause_circle : Icons.play_circle,
                  color: isPaused ? Colors.orange : Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPaused ? 'Check-Ins Paused' : 'Check-Ins Active',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isPaused && pausedSince != null)
                        Text(
                          'Since ${DateFormat('MMM d, y').format(pausedSince!)}',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: isPaused,
                  onChanged: (value) => _handleToggle(context),
                  activeColor: Colors.orange,
                ),
              ],
            ),
            if (isPaused) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Emergency alerts are disabled',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
