/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Still Alive';
  static const String appVersion = '1.0.0';

  // Check-in Window Constraints
  static const int minWindowDurationMinutes = 30; // 30 minutes minimum
  static const int maxWindowDurationMinutes = 240; // 4 hours maximum

  // Emergency Contacts Constraints
  static const int minEmergencyContacts = 2;
  static const int maxEmergencyContacts = 5;

  // Notification Timing (in minutes)
  static const int reminderBeforeWindowMinutes = 30;
  static const int reminderBeforeDeadlineMinutes = 15;

  // Alert Delays (in seconds)
  static const int smsDelaySeconds = 2; // Delay between SMS to different contacts
  static const int callDelaySeconds = 5; // Delay between calls to different contacts

  // Retry Settings
  static const int maxAlertRetries = 3;
  static const int retryDelaySeconds = 10;

  // Background Service
  static const String serviceChannelId = 'still_alive_service';
  static const String serviceChannelName = 'Check-in Monitoring';
  static const int serviceNotificationId = 1001;

  // Alert Notification
  static const String alertChannelId = 'still_alive_alerts';
  static const String alertChannelName = 'Emergency Alerts';
  static const int alertNotificationId = 2001;

  // Platform Channels
  static const String backgroundMethodChannel = 'com.stillalive/background';
  static const String backgroundEventChannel = 'com.stillalive/events';

  // History Settings
  static const int defaultHistoryDays = 30;
  static const List<int> historyDaysOptions = [7, 30, 90];
}
