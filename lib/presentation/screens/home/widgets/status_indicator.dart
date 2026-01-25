import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/checkin_status.dart';

/// Status indicator chip showing current check-in status
class StatusIndicator extends StatelessWidget {
  final CheckinStatus status;

  const StatusIndicator({
    super.key,
    required this.status,
  });

  Color _getColor() {
    switch (status) {
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
    switch (status) {
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

  String _getLabel() {
    switch (status) {
      case CheckinStatus.pending:
        return 'Window Not Open';
      case CheckinStatus.active:
        return 'Window Open - Check In Now';
      case CheckinStatus.completed:
        return 'Checked In Today';
      case CheckinStatus.missed:
        return 'Missed Check-In';
      case CheckinStatus.paused:
        return 'Check-Ins Paused';
      case CheckinStatus.manualAlert:
        return 'Emergency Alert Sent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            _getLabel(),
            style: AppTheme.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
