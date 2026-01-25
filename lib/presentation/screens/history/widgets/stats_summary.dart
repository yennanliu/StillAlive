import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Statistics summary widget
class StatsSummary extends StatelessWidget {
  final double completionRate;
  final int currentStreak;
  final int longestStreak;
  final int totalCompleted;
  final int totalMissed;

  const StatsSummary({
    super.key,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompleted,
    required this.totalMissed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Statistics',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.percent,
                    label: 'Completion Rate',
                    value: '${(completionRate * 100).toStringAsFixed(0)}%',
                    color: completionRate >= 0.8
                        ? Colors.green
                        : completionRate >= 0.5
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_fire_department,
                    label: 'Current Streak',
                    value: '$currentStreak day${currentStreak != 1 ? 's' : ''}',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.star,
                    label: 'Longest Streak',
                    value: '$longestStreak day${longestStreak != 1 ? 's' : ''}',
                    color: Colors.purple,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.check_circle,
                    label: 'Completed',
                    value: '$totalCompleted',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: Colors.grey[600],
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
