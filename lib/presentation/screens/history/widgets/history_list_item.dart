import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/checkin_record.dart';
import '../../../../data/models/checkin_status.dart';

/// Card widget for displaying a single check-in record
class HistoryListItem extends StatelessWidget {
  final CheckinRecord record;

  const HistoryListItem({super.key, required this.record});

  Color _getColor() {
    switch (record.status) {
      case CheckinStatus.pending:
        return Colors.grey;
      case CheckinStatus.active:
        return Colors.blue;
      case CheckinStatus.completed:
        return Colors.green;
      case CheckinStatus.missed:
        return Colors.red;
      case CheckinStatus.paused:
        return Colors.orange;
      case CheckinStatus.manualAlert:
        return Colors.red;
    }
  }

  IconData _getIcon() {
    switch (record.status) {
      case CheckinStatus.pending:
        return Icons.schedule;
      case CheckinStatus.active:
        return Icons.notifications_active;
      case CheckinStatus.completed:
        return Icons.check_circle;
      case CheckinStatus.missed:
        return Icons.error;
      case CheckinStatus.paused:
        return Icons.pause_circle;
      case CheckinStatus.manualAlert:
        return Icons.warning;
    }
  }

  String _getStatusText() {
    switch (record.status) {
      case CheckinStatus.pending:
        return 'Pending';
      case CheckinStatus.active:
        return 'Active';
      case CheckinStatus.completed:
        return 'Completed';
      case CheckinStatus.missed:
        return 'Missed';
      case CheckinStatus.paused:
        return 'Paused';
      case CheckinStatus.manualAlert:
        return 'Manual Alert';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isToday = record.date.isAtSameMomentAs(
      CheckinRecord.normalizeDate(DateTime.now()),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(_getIcon(), color: Colors.white),
        ),
        title: Row(
          children: [
            Text(
              DateFormat('EEE, MMM d, y').format(record.date),
              style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            if (isToday) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Today',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: color),
                const SizedBox(width: 6),
                Text(_getStatusText()),
              ],
            ),
            if (record.windowStart != null && record.windowEnd != null) ...[
              const SizedBox(height: 4),
              Text(
                'Window: ${record.windowStart!.format(context)} - ${record.windowEnd!.format(context)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            if (record.checkinTimestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                'Checked in: ${DateFormat('h:mm a').format(record.checkinTimestamp!)}',
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ],
            if (record.alertSent) ...[
              const SizedBox(height: 4),
              Text(
                'Alert sent to ${record.alertedContacts?.length ?? 0} contact${(record.alertedContacts?.length ?? 0) != 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
