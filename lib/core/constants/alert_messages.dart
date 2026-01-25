import 'package:intl/intl.dart';

/// Alert message templates for SMS and phone calls
class AlertMessages {
  // Date/time formatters
  static final DateFormat dateFormat = DateFormat('MMM d, yyyy');
  static final DateFormat timeFormat = DateFormat('h:mm a');
  static final DateFormat dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');

  /// Build SMS message for missed check-in
  static String buildMissedCheckinSMS({
    required String userName,
    required DateTime expectedDate,
    required String windowStart,
    required String windowEnd,
    DateTime? lastCheckinDate,
  }) {
    final lastCheckinText = lastCheckinDate != null
        ? 'Last successful check-in: ${dateTimeFormat.format(lastCheckinDate)}'
        : 'No previous check-ins recorded';

    return '''STILL ALIVE APP ALERT

$userName has missed their daily check-in.

Expected check-in: ${dateFormat.format(expectedDate)}, $windowStart - $windowEnd
$lastCheckinText

This may indicate they need assistance. Please contact them immediately or check on their wellbeing.

If this is a false alarm, ask them to open the Still Alive app.''';
  }

  /// Build phone call script for missed check-in
  static String buildMissedCheckinCallScript({
    required String userName,
    DateTime? lastCheckinDate,
  }) {
    final lastCheckinText = lastCheckinDate != null
        ? 'Their last check-in was on ${dateTimeFormat.format(lastCheckinDate)}.'
        : 'There are no previous check-ins recorded.';

    return '''This is an automated safety alert from the Still Alive application.

$userName has missed their scheduled daily check-in today.

$lastCheckinText

This may indicate they need assistance.

Please contact $userName immediately or check on their wellbeing.

Thank you.''';
  }

  /// Build SMS message for manual emergency trigger
  static String buildManualEmergencySMS({
    required String userName,
    required DateTime timestamp,
    String? location,
  }) {
    final locationText = location != null ? '\nLocation: $location' : '';

    return '''STILL ALIVE APP - EMERGENCY

$userName has manually triggered an emergency alert.

Timestamp: ${dateTimeFormat.format(timestamp)}$locationText

Please contact them immediately or check on their wellbeing.

This alert was sent from the Still Alive app.''';
  }

  /// Build phone call script for manual emergency
  static String buildManualEmergencyCallScript({required String userName}) {
    return '''This is an EMERGENCY alert from the Still Alive application.

$userName has manually triggered an emergency alert just now.

This indicates they need immediate assistance.

Please contact $userName immediately or check on their wellbeing.

Thank you.''';
  }

  /// Build test SMS message
  static String buildTestSMS({required String userName}) {
    return '''STILL ALIVE APP - TEST

This is a test message from $userName's Still Alive app.

You have been added as an emergency contact. In case $userName misses their daily check-in, you will receive an alert like this.

No action needed at this time.''';
  }
}
