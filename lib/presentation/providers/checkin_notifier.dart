import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/checkin_record.dart';
import '../../data/models/checkin_status.dart';
import '../../data/models/user_settings.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../data/repositories/settings_repository.dart';

/// State class for check-in information
class CheckinState {
  final CheckinRecord? todayRecord;
  final CheckinStatus currentStatus;
  final Duration? timeRemaining;
  final DateTime? nextWindowStart;
  final UserSettings settings;

  CheckinState({
    this.todayRecord,
    required this.currentStatus,
    this.timeRemaining,
    this.nextWindowStart,
    required this.settings,
  });

  CheckinState copyWith({
    CheckinRecord? todayRecord,
    CheckinStatus? currentStatus,
    Duration? timeRemaining,
    DateTime? nextWindowStart,
    UserSettings? settings,
  }) {
    return CheckinState(
      todayRecord: todayRecord ?? this.todayRecord,
      currentStatus: currentStatus ?? this.currentStatus,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      nextWindowStart: nextWindowStart ?? this.nextWindowStart,
      settings: settings ?? this.settings,
    );
  }
}

/// Notifier for managing check-in state
class CheckinNotifier extends StateNotifier<CheckinState> {
  final CheckinRepository _checkinRepository;
  final SettingsRepository _settingsRepository;
  Timer? _timer;

  CheckinNotifier({
    required CheckinRepository checkinRepository,
    required SettingsRepository settingsRepository,
  }) : _checkinRepository = checkinRepository,
       _settingsRepository = settingsRepository,
       super(
         CheckinState(
           currentStatus: CheckinStatus.pending,
           settings: settingsRepository.getSettings(),
         ),
       ) {
    _initialize();
  }

  /// Initialize the notifier and start timer
  void _initialize() {
    _updateState();
    // Update state every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateState();
    });
  }

  /// Update the current state
  void _updateState() {
    final now = DateTime.now();
    final settings = _settingsRepository.getSettings();
    final todayRecord = _checkinRepository.getTodayRecord();

    final status = calculateStatus(now, settings, todayRecord);
    final timeRemaining = _calculateTimeRemaining(now, settings, status);
    final nextWindowStart = _calculateNextWindowStart(now, settings, status);

    state = CheckinState(
      todayRecord: todayRecord,
      currentStatus: status,
      timeRemaining: timeRemaining,
      nextWindowStart: nextWindowStart,
      settings: settings,
    );
  }

  /// Calculate the current check-in status
  CheckinStatus calculateStatus(
    DateTime now,
    UserSettings settings,
    CheckinRecord? todayRecord,
  ) {
    // If app is paused, status is paused
    if (settings.isPaused) {
      return CheckinStatus.paused;
    }

    // If already completed today, status is completed
    if (todayRecord?.status == CheckinStatus.completed) {
      return CheckinStatus.completed;
    }

    // If manual alert was triggered, show that status
    if (todayRecord?.status == CheckinStatus.manualAlert) {
      return CheckinStatus.manualAlert;
    }

    // Calculate current time in minutes from midnight
    final currentMinutes = now.hour * 60 + now.minute;

    // Before window starts
    if (currentMinutes < settings.checkinWindowStartMinutes) {
      return CheckinStatus.pending;
    }

    // Window is currently open
    if (currentMinutes <= settings.checkinWindowEndMinutes) {
      return CheckinStatus.active;
    }

    // After window ends without check-in
    return CheckinStatus.missed;
  }

  /// Calculate time remaining in the current window
  Duration? _calculateTimeRemaining(
    DateTime now,
    UserSettings settings,
    CheckinStatus status,
  ) {
    if (status != CheckinStatus.active) {
      return null;
    }

    final currentMinutes = now.hour * 60 + now.minute;
    final remainingMinutes = settings.checkinWindowEndMinutes - currentMinutes;

    return Duration(minutes: remainingMinutes);
  }

  /// Calculate when the next window will start
  DateTime? _calculateNextWindowStart(
    DateTime now,
    UserSettings settings,
    CheckinStatus status,
  ) {
    if (status == CheckinStatus.active || status == CheckinStatus.completed) {
      return null;
    }

    // Next window is tomorrow at the start time
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final nextStart = tomorrow.add(
      Duration(minutes: settings.checkinWindowStartMinutes),
    );

    return nextStart;
  }

  /// Complete today's check-in
  Future<void> completeCheckin() async {
    final todayRecord = _checkinRepository.getTodayRecord();

    if (todayRecord != null) {
      // Update existing record
      await _checkinRepository.completeTodayCheckin();
    } else {
      // Create new completed record
      final settings = _settingsRepository.getSettings();
      await _checkinRepository.createTodayRecord(
        status: CheckinStatus.completed,
        windowStartMinutes: settings.checkinWindowStartMinutes,
        windowEndMinutes: settings.checkinWindowEndMinutes,
      );

      // Mark as completed
      await _checkinRepository.updateTodayStatus(CheckinStatus.completed);
    }

    _updateState();
  }

  /// Trigger manual emergency alert
  Future<void> triggerManualAlert() async {
    final todayRecord = _checkinRepository.getTodayRecord();

    if (todayRecord != null) {
      await _checkinRepository.updateTodayStatus(CheckinStatus.manualAlert);
    } else {
      final settings = _settingsRepository.getSettings();
      await _checkinRepository.createTodayRecord(
        status: CheckinStatus.manualAlert,
        windowStartMinutes: settings.checkinWindowStartMinutes,
        windowEndMinutes: settings.checkinWindowEndMinutes,
      );
      await _checkinRepository.updateTodayStatus(CheckinStatus.manualAlert);
    }

    _updateState();
  }

  /// Refresh the state (useful after settings change)
  void refresh() {
    _updateState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
