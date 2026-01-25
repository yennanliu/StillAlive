import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/checkin_record.dart';
import '../../data/models/checkin_status.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/contacts_repository.dart';

/// State class for home screen
class HomeScreenState {
  final CheckinRecord? todayRecord;
  final CheckinStatus currentStatus;
  final Duration? timeRemaining;
  final bool isPaused;
  final DateTime? pausedSince;
  final int currentStreak;
  final bool hasMinimumContacts;
  final int contactCount;

  HomeScreenState({
    this.todayRecord,
    required this.currentStatus,
    this.timeRemaining,
    required this.isPaused,
    this.pausedSince,
    required this.currentStreak,
    required this.hasMinimumContacts,
    required this.contactCount,
  });

  HomeScreenState copyWith({
    CheckinRecord? todayRecord,
    CheckinStatus? currentStatus,
    Duration? timeRemaining,
    bool? isPaused,
    DateTime? pausedSince,
    int? currentStreak,
    bool? hasMinimumContacts,
    int? contactCount,
  }) {
    return HomeScreenState(
      todayRecord: todayRecord ?? this.todayRecord,
      currentStatus: currentStatus ?? this.currentStatus,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isPaused: isPaused ?? this.isPaused,
      pausedSince: pausedSince ?? this.pausedSince,
      currentStreak: currentStreak ?? this.currentStreak,
      hasMinimumContacts: hasMinimumContacts ?? this.hasMinimumContacts,
      contactCount: contactCount ?? this.contactCount,
    );
  }
}

/// Notifier for managing home screen state
class HomeNotifier extends StateNotifier<HomeScreenState> {
  final CheckinRepository _checkinRepository;
  final SettingsRepository _settingsRepository;
  final ContactsRepository _contactsRepository;

  HomeNotifier({
    required CheckinRepository checkinRepository,
    required SettingsRepository settingsRepository,
    required ContactsRepository contactsRepository,
  })  : _checkinRepository = checkinRepository,
        _settingsRepository = settingsRepository,
        _contactsRepository = contactsRepository,
        super(HomeScreenState(
          currentStatus: CheckinStatus.pending,
          isPaused: false,
          currentStreak: 0,
          hasMinimumContacts: false,
          contactCount: 0,
        )) {
    _updateState();
  }

  /// Update the home screen state
  void _updateState() {
    final settings = _settingsRepository.getSettings();
    final todayRecord = _checkinRepository.getTodayRecord();
    final currentStatus = _calculateStatus(todayRecord, settings);
    final timeRemaining = _calculateTimeRemaining(settings, currentStatus);
    final streak = _calculateCurrentStreak();
    final hasMinContacts = _contactsRepository.hasMinimumContacts();
    final contactCount = _contactsRepository.getContactCount();

    state = HomeScreenState(
      todayRecord: todayRecord,
      currentStatus: currentStatus,
      timeRemaining: timeRemaining,
      isPaused: settings.isPaused,
      pausedSince: settings.pausedSince,
      currentStreak: streak,
      hasMinimumContacts: hasMinContacts,
      contactCount: contactCount,
    );
  }

  /// Calculate current status
  CheckinStatus _calculateStatus(
    CheckinRecord? todayRecord,
    dynamic settings,
  ) {
    if (settings.isPaused) {
      return CheckinStatus.paused;
    }

    if (todayRecord?.status == CheckinStatus.completed) {
      return CheckinStatus.completed;
    }

    if (todayRecord?.status == CheckinStatus.manualAlert) {
      return CheckinStatus.manualAlert;
    }

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    if (currentMinutes < settings.checkinWindowStartMinutes) {
      return CheckinStatus.pending;
    }

    if (currentMinutes <= settings.checkinWindowEndMinutes) {
      return CheckinStatus.active;
    }

    return CheckinStatus.missed;
  }

  /// Calculate time remaining
  Duration? _calculateTimeRemaining(dynamic settings, CheckinStatus status) {
    if (status != CheckinStatus.active) {
      return null;
    }

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final remainingMinutes =
        settings.checkinWindowEndMinutes - currentMinutes;

    return Duration(minutes: remainingMinutes);
  }

  /// Calculate current streak of completed check-ins
  int _calculateCurrentStreak() {
    final history = _checkinRepository.getHistory(days: 365);
    if (history.isEmpty) return 0;

    int streak = 0;
    final today = CheckinRecord.normalizeDate(DateTime.now());

    // Start from today and go backwards
    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final record = history.firstWhere(
        (r) => r.date.isAtSameMomentAs(date),
        orElse: () => CheckinRecord(
          id: '',
          date: date,
          status: CheckinStatus.missed,
        ),
      );

      // Count completed or paused days as part of streak
      if (record.status == CheckinStatus.completed ||
          record.status == CheckinStatus.paused) {
        streak++;
      } else if (i > 0) {
        // Don't break streak on first day (today) if not completed yet
        break;
      }
    }

    return streak;
  }

  /// Refresh the state
  void refresh() {
    _updateState();
  }
}
