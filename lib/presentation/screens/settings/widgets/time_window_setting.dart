import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_settings.dart';

/// Widget for displaying and editing the check-in time window
class TimeWindowSetting extends StatelessWidget {
  final UserSettings settings;
  final Function(TimeOfDay start, TimeOfDay end) onUpdate;

  const TimeWindowSetting({
    super.key,
    required this.settings,
    required this.onUpdate,
  });

  Future<void> _editTimeWindow(BuildContext context) async {
    TimeOfDay newStart = settings.checkinWindowStart;
    TimeOfDay newEnd = settings.checkinWindowEnd;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Check-in Window'),
        content: StatefulBuilder(
          builder: (context, setState) {
            final duration =
                (newEnd.hour * 60 + newEnd.minute) -
                (newStart.hour * 60 + newStart.minute);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Window Start'),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: newStart,
                      );
                      if (picked != null) {
                        setState(() {
                          newStart = picked;
                        });
                      }
                    },
                    child: Text(
                      newStart.format(context),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Window End'),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: newEnd,
                      );
                      if (picked != null) {
                        setState(() {
                          newEnd = picked;
                        });
                      }
                    },
                    child: Text(
                      newEnd.format(context),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: duration >= 30 && duration <= 240
                        ? Colors.blue[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Duration: $duration minutes\n'
                    'Valid range: 30-240 minutes',
                    style: TextStyle(
                      fontSize: 12,
                      color: duration >= 30 && duration <= 240
                          ? Colors.blue[900]
                          : Colors.red[900],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final duration =
                  (newEnd.hour * 60 + newEnd.minute) -
                  (newStart.hour * 60 + newStart.minute);
              if (duration >= 30 && duration <= 240) {
                onUpdate(newStart, newEnd);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = settings.checkinWindowStart;
    final end = settings.checkinWindowEnd;

    return Card(
      child: ListTile(
        leading: Icon(Icons.access_time, color: AppTheme.primaryColor),
        title: const Text('Check-in Window'),
        subtitle: Text(
          '${start.format(context)} - ${end.format(context)}',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.edit),
        onTap: () => _editTimeWindow(context),
      ),
    );
  }
}
