import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Countdown timer showing time remaining in check-in window
class CountdownTimer extends StatelessWidget {
  final Duration? timeRemaining;

  const CountdownTimer({
    super.key,
    this.timeRemaining,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    } else {
      return '${minutes}m remaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (timeRemaining == null) {
      return const SizedBox.shrink();
    }

    final isUrgent = timeRemaining!.inMinutes <= 15;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? Colors.red : Colors.blue,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isUrgent ? Colors.red : Colors.blue,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDuration(timeRemaining!),
                style: AppTheme.headlineSmall.copyWith(
                  color: isUrgent ? Colors.red : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isUrgent ? 'Check in soon!' : 'Window closes soon',
                style: AppTheme.bodySmall.copyWith(
                  color: isUrgent ? Colors.red[800] : Colors.blue[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
