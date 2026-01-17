/// Keys for SharedPreferences storage
class StorageKeys {
  // SharedPreferences keys
  static const String lastCheckinDate = 'last_checkin_date';
  static const String backgroundServiceRunning = 'background_service_running';
  static const String lastAlertSent = 'last_alert_sent';
  static const String appVersion = 'app_version';

  // Hive box names (also defined in StorageService, but duplicated here for reference)
  static const String settingsBox = 'settings_box';
  static const String contactsBox = 'contacts_box';
  static const String checkinBox = 'checkin_box';
}
