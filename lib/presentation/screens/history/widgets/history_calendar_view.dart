import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../data/models/checkin_record.dart';
import '../../../../data/models/checkin_status.dart';
import 'status_legend.dart';

/// Calendar view with color-coded check-in status
class HistoryCalendarView extends StatefulWidget {
  final List<CheckinRecord> records;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  const HistoryCalendarView({
    super.key,
    required this.records,
    required this.rangeStart,
    required this.rangeEnd,
  });

  @override
  State<HistoryCalendarView> createState() => _HistoryCalendarViewState();
}

class _HistoryCalendarViewState extends State<HistoryCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  CheckinRecord _getRecordForDay(DateTime day) {
    final normalized = CheckinRecord.normalizeDate(day);
    try {
      return widget.records.firstWhere(
        (record) => record.date.isAtSameMomentAs(normalized),
      );
    } catch (e) {
      // Return a default pending record if not found
      return CheckinRecord(
        id: '',
        date: normalized,
        status: CheckinStatus.pending,
      );
    }
  }

  Color _getColorForDay(DateTime day) {
    final record = _getRecordForDay(day);

    // Don't color future dates
    if (day.isAfter(DateTime.now())) {
      return Colors.transparent;
    }

    switch (record.status) {
      case CheckinStatus.completed:
        return Colors.green;
      case CheckinStatus.missed:
        return Colors.red;
      case CheckinStatus.paused:
        return Colors.orange;
      case CheckinStatus.manualAlert:
        return Colors.red;
      default:
        return Colors.grey[300]!;
    }
  }

  void _showDayDetails(DateTime day) {
    final record = _getRecordForDay(day);

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${day.day}/${day.month}/${day.year}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.circle,
              label: 'Status',
              value: record.status.name.toUpperCase(),
              valueColor: _getColorForDay(day),
            ),
            if (record.windowStart != null && record.windowEnd != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.access_time,
                label: 'Window',
                value:
                    '${record.windowStart!.format(context)} - ${record.windowEnd!.format(context)}',
              ),
            ],
            if (record.checkinTimestamp != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.check_circle,
                label: 'Checked In',
                value: TimeOfDay.fromDateTime(record.checkinTimestamp!)
                    .format(context),
                valueColor: Colors.green,
              ),
            ],
            if (record.alertSent) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.warning,
                label: 'Alert Sent',
                value: 'Yes',
                valueColor: Colors.red,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatusLegend(),
        Expanded(
          child: TableCalendar(
            firstDay: widget.rangeStart,
            lastDay: widget.rangeEnd,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.twoWeeks,
            availableGestures: AvailableGestures.horizontalSwipe,
            daysOfWeekHeight: 24,
            rowHeight: 34,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showDayDetails(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronPadding: EdgeInsets.zero,
              rightChevronPadding: EdgeInsets.zero,
              titleTextStyle: TextStyle(fontSize: 15),
              headerPadding: EdgeInsets.symmetric(vertical: 4),
              headerMargin: EdgeInsets.only(bottom: 4),
            ),
            calendarStyle: CalendarStyle(
              markersMaxCount: 0,
              cellMargin: const EdgeInsets.all(4),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColorForDay(day),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: _getColorForDay(day) == Colors.transparent ||
                                _getColorForDay(day) == Colors.grey[300]
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColorForDay(day),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
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
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(color: valueColor),
        ),
      ],
    );
  }
}
