import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_settings.dart';
import '../../data/repositories/settings_repository.dart';

/// Notifier for managing user settings
class SettingsNotifier extends StateNotifier<UserSettings> {
  final SettingsRepository _repository;

  SettingsNotifier({
    required SettingsRepository repository,
  })  : _repository = repository,
        super(repository.getSettings());

  /// Update user name
  Future<void> updateUserName(String name) async {
    await _repository.updateSettings(userName: name);
    state = _repository.getSettings();
  }

  /// Update check-in window times
  Future<void> updateCheckinWindow({
    TimeOfDay? start,
    TimeOfDay? end,
  }) async {
    final startMinutes = start != null ? start.hour * 60 + start.minute : null;
    final endMinutes = end != null ? end.hour * 60 + end.minute : null;

    await _repository.updateSettings(
      checkinWindowStartMinutes: startMinutes,
      checkinWindowEndMinutes: endMinutes,
    );
    state = _repository.getSettings();
  }

  /// Pause check-ins
  Future<void> pauseCheckins() async {
    await _repository.updateSettings(
      isPaused: true,
      pausedSince: DateTime.now(),
    );
    state = _repository.getSettings();
  }

  /// Resume check-ins
  Future<void> resumeCheckins() async {
    await _repository.updateSettings(
      isPaused: false,
      pausedSince: null,
    );
    state = _repository.getSettings();
  }

  /// Toggle notifications enabled
  Future<void> toggleNotifications(bool enabled) async {
    await _repository.updateSettings(notificationsEnabled: enabled);
    state = _repository.getSettings();
  }

  /// Toggle reminder before window
  Future<void> toggleReminderBeforeWindow(bool enabled) async {
    await _repository.updateSettings(reminderBeforeWindow: enabled);
    state = _repository.getSettings();
  }

  /// Toggle reminder at window start
  Future<void> toggleReminderAtWindowStart(bool enabled) async {
    await _repository.updateSettings(reminderAtWindowStart: enabled);
    state = _repository.getSettings();
  }

  /// Toggle reminder before deadline
  Future<void> toggleReminderBeforeDeadline(bool enabled) async {
    await _repository.updateSettings(reminderBeforeDeadline: enabled);
    state = _repository.getSettings();
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _repository.updateSettings(onboardingCompleted: true);
    state = _repository.getSettings();
  }

  /// Refresh settings from repository
  void refresh() {
    state = _repository.getSettings();
  }
}
