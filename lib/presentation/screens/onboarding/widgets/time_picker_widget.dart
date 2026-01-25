import 'package:flutter/material.dart';

/// Time picker widget for selecting window start/end times
class TimePickerWidget extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePickerWidget({
    super.key,
    required this.label,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        onTap: () async {
          final newTime = await showTimePicker(
            context: context,
            initialTime: time,
          );
          if (newTime != null) {
            onTimeChanged(newTime);
          }
        },
      ),
    );
  }
}
