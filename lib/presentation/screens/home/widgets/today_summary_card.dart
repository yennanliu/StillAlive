import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/checkin_record.dart';
import '../../../../data/models/user_settings.dart';

/// Summary card showing today's check-in information
class TodaySummaryCard extends StatelessWidget {
  final CheckinRecord? todayRecord;
  final UserSettings settings;
  final int currentStreak;

  const TodaySummaryCard({
    super.key,
    this.todayRecord,
    required this.settings,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final windowStart = settings.checkinWindowStart;
    final windowEnd = settings.checkinWindowEnd;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Today',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Check-in Window',
              value:
                  '${windowStart.format(context)} - ${windowEnd.format(context)}',
            ),
            if (todayRecord?.checkinTimestamp != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.check_circle,
                label: 'Checked In At',
                value: DateFormat(
                  'h:mm a',
                ).format(todayRecord!.checkinTimestamp!),
                valueColor: Colors.green,
              ),
            ],
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.local_fire_department,
              label: 'Current Streak',
              value: '$currentStreak day${currentStreak != 1 ? 's' : ''}',
              valueColor: currentStreak > 0 ? Colors.orange : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(color: Colors.grey[700]),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
