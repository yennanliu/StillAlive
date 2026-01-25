import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/time_picker_widget.dart';

/// Time window page - set daily check-in window
class TimeWindowPage extends StatefulWidget {
  final TimeOfDay initialStart;
  final TimeOfDay initialEnd;
  final Function(TimeOfDay start, TimeOfDay end) onContinue;

  const TimeWindowPage({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.onContinue,
  });

  @override
  State<TimeWindowPage> createState() => _TimeWindowPageState();
}

class _TimeWindowPageState extends State<TimeWindowPage> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStart;
    _endTime = widget.initialEnd;
    _validateWindow();
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void _validateWindow() {
    final startMinutes = _timeToMinutes(_startTime);
    final endMinutes = _timeToMinutes(_endTime);
    final duration = endMinutes - startMinutes;

    if (duration < 30) {
      _errorMessage = 'Window must be at least 30 minutes';
    } else if (duration > 240) {
      _errorMessage = 'Window cannot exceed 4 hours (240 minutes)';
    } else if (duration < 0) {
      _errorMessage = 'End time must be after start time';
    } else {
      _errorMessage = null;
    }
  }

  void _handleContinue() {
    _validateWindow();
    if (_errorMessage == null) {
      widget.onContinue(_startTime, _endTime);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = _timeToMinutes(_endTime) - _timeToMinutes(_startTime);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Check-in Window',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a daily time window when you\'ll check in:',
            style: AppTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          TimePickerWidget(
            label: 'Window Start',
            time: _startTime,
            onTimeChanged: (newTime) {
              setState(() {
                _startTime = newTime;
                _validateWindow();
              });
            },
          ),
          const SizedBox(height: 16),
          TimePickerWidget(
            label: 'Window End',
            time: _endTime,
            onTimeChanged: (newTime) {
              setState(() {
                _endTime = newTime;
                _validateWindow();
              });
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _errorMessage == null ? Colors.blue[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _errorMessage == null ? Colors.blue : Colors.red,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _errorMessage == null ? Icons.info : Icons.error,
                  color: _errorMessage == null ? Colors.blue : Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage == null) ...[
                        Text(
                          'Window Duration: ${duration} minutes',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Valid range: 30-240 minutes',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ] else ...[
                        Text(
                          _errorMessage!,
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.tips_and_updates, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Recommendations',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Choose a time when you\'re usually active\n'
                  '• Morning windows (8-10 AM) work well for most people\n'
                  '• A 2-hour window gives you flexibility',
                  style: AppTheme.bodySmall.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _errorMessage == null ? _handleContinue : null,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
