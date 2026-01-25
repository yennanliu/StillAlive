import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/checkin_record.dart';
import '../../data/models/checkin_status.dart';
import '../../data/repositories/checkin_repository.dart';

/// View mode for history screen
enum HistoryViewMode { calendar, list }

/// State class for history screen
class HistoryState {
  final List<CheckinRecord> records;
  final HistoryViewMode viewMode;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final double completionRate;
  final int currentStreak;
  final int longestStreak;
  final int totalCompleted;
  final int totalMissed;

  HistoryState({
    required this.records,
    required this.viewMode,
    required this.rangeStart,
    required this.rangeEnd,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCompleted,
    required this.totalMissed,
  });

  HistoryState copyWith({
    List<CheckinRecord>? records,
    HistoryViewMode? viewMode,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    double? completionRate,
    int? currentStreak,
    int? longestStreak,
    int? totalCompleted,
    int? totalMissed,
  }) {
    return HistoryState(
      records: records ?? this.records,
      viewMode: viewMode ?? this.viewMode,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
      completionRate: completionRate ?? this.completionRate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompleted: totalCompleted ?? this.totalCompleted,
      totalMissed: totalMissed ?? this.totalMissed,
    );
  }
}

/// Notifier for managing history state
class HistoryNotifier extends StateNotifier<HistoryState> {
  final CheckinRepository _repository;

  HistoryNotifier({required CheckinRepository repository})
    : _repository = repository,
      super(
        HistoryState(
          records: [],
          viewMode: HistoryViewMode.calendar,
          rangeStart: DateTime.now().subtract(const Duration(days: 30)),
          rangeEnd: DateTime.now(),
          completionRate: 0.0,
          currentStreak: 0,
          longestStreak: 0,
          totalCompleted: 0,
          totalMissed: 0,
        ),
      ) {
    _updateState();
  }

  /// Update history state
  void _updateState() {
    final records = _repository.getHistoryByDateRange(
      state.rangeStart,
      state.rangeEnd,
    );

    final stats = _calculateStats(records);

    state = state.copyWith(
      records: records,
      completionRate: stats['completionRate'] as double,
      currentStreak: stats['currentStreak'] as int,
      longestStreak: stats['longestStreak'] as int,
      totalCompleted: stats['totalCompleted'] as int,
      totalMissed: stats['totalMissed'] as int,
    );
  }

  /// Calculate statistics from records
  Map<String, dynamic> _calculateStats(List<CheckinRecord> records) {
    if (records.isEmpty) {
      return {
        'completionRate': 0.0,
        'currentStreak': 0,
        'longestStreak': 0,
        'totalCompleted': 0,
        'totalMissed': 0,
      };
    }

    final completed = records
        .where((r) => r.status == CheckinStatus.completed)
        .length;
    final missed = records
        .where((r) => r.status == CheckinStatus.missed)
        .length;

    // Calculate completion rate (exclude paused days)
    final eligibleDays = records
        .where((r) => r.status != CheckinStatus.paused)
        .length;
    final completionRate = eligibleDays > 0 ? completed / eligibleDays : 0.0;

    // Calculate current streak
    final currentStreak = _calculateCurrentStreak(records);

    // Calculate longest streak
    final longestStreak = _calculateLongestStreak(records);

    return {
      'completionRate': completionRate,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompleted': completed,
      'totalMissed': missed,
    };
  }

  /// Calculate current streak
  int _calculateCurrentStreak(List<CheckinRecord> records) {
    if (records.isEmpty) return 0;

    final sortedRecords = records.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    final today = CheckinRecord.normalizeDate(DateTime.now());

    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final record = sortedRecords.firstWhere(
        (r) => r.date.isAtSameMomentAs(date),
        orElse: () =>
            CheckinRecord(id: '', date: date, status: CheckinStatus.missed),
      );

      if (record.status == CheckinStatus.completed ||
          record.status == CheckinStatus.paused) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return streak;
  }

  /// Calculate longest streak in the records
  int _calculateLongestStreak(List<CheckinRecord> records) {
    if (records.isEmpty) return 0;

    final sortedRecords = records.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? previousDate;

    for (final record in sortedRecords) {
      if (record.status == CheckinStatus.completed ||
          record.status == CheckinStatus.paused) {
        if (previousDate == null ||
            record.date.difference(previousDate).inDays == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak
              ? currentStreak
              : longestStreak;
        } else {
          currentStreak = 1;
        }
        previousDate = record.date;
      } else {
        currentStreak = 0;
        previousDate = null;
      }
    }

    return longestStreak;
  }

  /// Toggle view mode between calendar and list
  void toggleViewMode() {
    state = state.copyWith(
      viewMode: state.viewMode == HistoryViewMode.calendar
          ? HistoryViewMode.list
          : HistoryViewMode.calendar,
    );
  }

  /// Set view mode
  void setViewMode(HistoryViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// Update date range
  void updateDateRange(DateTime start, DateTime end) {
    state = state.copyWith(rangeStart: start, rangeEnd: end);
    _updateState();
  }

  /// Set to last 30 days
  void setLast30Days() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 30));
    updateDateRange(start, end);
  }

  /// Set to last 90 days
  void setLast90Days() {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 90));
    updateDateRange(start, end);
  }

  /// Set to current month
  void setCurrentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    updateDateRange(start, end);
  }

  /// Refresh history
  void refresh() {
    _updateState();
  }
}
