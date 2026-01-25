import '../models/user_settings.dart';
import '../services/storage_service.dart';

/// Repository for managing user settings in Hive
class SettingsRepository {
  final StorageService _storage;

  SettingsRepository({StorageService? storage})
    : _storage = storage ?? StorageService();

  static const String _settingsKey = 'user_settings';

  /// Get user settings (or create defaults if not found)
  UserSettings getSettings() {
    final box = _storage.settingsBox;
    UserSettings? settings = box.get(_settingsKey);

    if (settings == null) {
      settings = UserSettings.defaults();
      box.put(_settingsKey, settings);
    }

    return settings;
  }

  /// Save user settings
  Future<void> saveSettings(UserSettings settings) async {
    final box = _storage.settingsBox;
    await box.put(_settingsKey, settings);
  }

  /// Update specific fields of settings
  Future<void> updateSettings({
    String? userName,
    int? checkinWindowStartMinutes,
    int? checkinWindowEndMinutes,
    bool? isPaused,
    DateTime? pausedSince,
    bool? notificationsEnabled,
    bool? reminderBeforeWindow,
    bool? reminderAtWindowStart,
    bool? reminderBeforeDeadline,
    bool? onboardingCompleted,
  }) async {
    final settings = getSettings();

    if (userName != null) settings.userName = userName;
    if (checkinWindowStartMinutes != null) {
      settings.checkinWindowStartMinutes = checkinWindowStartMinutes;
    }
    if (checkinWindowEndMinutes != null) {
      settings.checkinWindowEndMinutes = checkinWindowEndMinutes;
    }
    if (isPaused != null) settings.isPaused = isPaused;
    if (pausedSince != null) settings.pausedSince = pausedSince;
    if (notificationsEnabled != null) {
      settings.notificationsEnabled = notificationsEnabled;
    }
    if (reminderBeforeWindow != null) {
      settings.reminderBeforeWindow = reminderBeforeWindow;
    }
    if (reminderAtWindowStart != null) {
      settings.reminderAtWindowStart = reminderAtWindowStart;
    }
    if (reminderBeforeDeadline != null) {
      settings.reminderBeforeDeadline = reminderBeforeDeadline;
    }
    if (onboardingCompleted != null) {
      settings.onboardingCompleted = onboardingCompleted;
    }

    await settings.save();
  }

  /// Check if onboarding is completed
  bool isOnboardingCompleted() {
    return getSettings().onboardingCompleted;
  }

  /// Check if app is paused
  bool isPaused() {
    return getSettings().isPaused;
  }

  /// Delete all settings
  Future<void> deleteSettings() async {
    final box = _storage.settingsBox;
    await box.delete(_settingsKey);
  }
}
