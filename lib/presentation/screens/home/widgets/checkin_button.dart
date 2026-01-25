import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/checkin_status.dart';

/// Large circular check-in button
class CheckinButton extends StatelessWidget {
  final CheckinStatus status;
  final VoidCallback onPressed;

  const CheckinButton({
    super.key,
    required this.status,
    required this.onPressed,
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
        return Icons.touch_app;
      case CheckinStatus.completed:
        return Icons.check_circle;
      case CheckinStatus.missed:
        return Icons.error;
      case CheckinStatus.paused:
        return Icons.pause;
      case CheckinStatus.manualAlert:
        return Icons.warning;
    }
  }

  String _getLabel() {
    switch (status) {
      case CheckinStatus.pending:
        return 'Window Not Open';
      case CheckinStatus.active:
        return 'Check In';
      case CheckinStatus.completed:
        return 'Checked In';
      case CheckinStatus.missed:
        return 'Missed';
      case CheckinStatus.paused:
        return 'Paused';
      case CheckinStatus.manualAlert:
        return 'Alert Sent';
    }
  }

  bool get _isEnabled => status == CheckinStatus.active;

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isEnabled = _isEnabled;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled ? color : color.withOpacity(0.3),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getIcon(), size: 80, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              _getLabel(),
              style: AppTheme.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
