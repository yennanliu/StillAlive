import '../models/checkin_record.dart';
import '../models/checkin_status.dart';
import '../services/storage_service.dart';

/// Repository for managing check-in records in Hive
class CheckinRepository {
  final StorageService _storage;

  CheckinRepository({StorageService? storage})
      : _storage = storage ?? StorageService();

  /// Get check-in record for a specific date
  CheckinRecord? getRecordByDate(DateTime date) {
    final normalizedDate = CheckinRecord.normalizeDate(date);
    final key = _dateToKey(normalizedDate);
    final box = _storage.checkinBox;
    return box.get(key);
  }

  /// Get today's check-in record
  CheckinRecord? getTodayRecord() {
    return getRecordByDate(DateTime.now());
  }

  /// Save a check-in record
  Future<void> saveRecord(CheckinRecord record) async {
    final box = _storage.checkinBox;
    final key = record.dateKey;
    await box.put(key, record);
  }

  /// Create a new check-in record for today
  Future<CheckinRecord> createTodayRecord({
    required CheckinStatus status,
    int? windowStartMinutes,
    int? windowEndMinutes,
  }) async {
    final today = CheckinRecord.normalizeDate(DateTime.now());
    final record = CheckinRecord(
      id: _generateId(),
      date: today,
      status: status,
      windowStartMinutes: windowStartMinutes,
      windowEndMinutes: windowEndMinutes,
    );
    await saveRecord(record);
    return record;
  }

  /// Update check-in status for today
  Future<void> updateTodayStatus(CheckinStatus status) async {
    final record = getTodayRecord();
    if (record != null) {
      record.status = status;
      if (status == CheckinStatus.completed) {
        record.checkinTimestamp = DateTime.now();
      }
      await record.save();
    }
  }

  /// Mark today's check-in as completed
  Future<void> completeTodayCheckin() async {
    final record = getTodayRecord();
    if (record != null) {
      record.status = CheckinStatus.completed;
      record.checkinTimestamp = DateTime.now();
      await record.save();
    }
  }

  /// Mark check-in as missed and log alert
  Future<void> markAsMissed(
    DateTime date,
    List<String> contactIds,
  ) async {
    final record = getRecordByDate(date);
    if (record != null) {
      record.status = CheckinStatus.missed;
      record.alertSent = true;
      record.alertSentAt = DateTime.now();
      record.alertedContacts = contactIds;
      await record.save();
    }
  }

  /// Get check-in history for the last N days
  List<CheckinRecord> getHistory({int days = 30}) {
    final box = _storage.checkinBox;
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: days));

    return box.values
        .where((record) => record.date.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  }

  /// Get check-in history for a date range
  List<CheckinRecord> getHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final box = _storage.checkinBox;
    final normalizedStart = CheckinRecord.normalizeDate(startDate);
    final normalizedEnd = CheckinRecord.normalizeDate(endDate);

    return box.values
        .where((record) =>
            !record.date.isBefore(normalizedStart) &&
            !record.date.isAfter(normalizedEnd))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get count of completed check-ins
  int getCompletedCount({int days = 30}) {
    return getHistory(days: days)
        .where((record) => record.status == CheckinStatus.completed)
        .length;
  }

  /// Get count of missed check-ins
  int getMissedCount({int days = 30}) {
    return getHistory(days: days)
        .where((record) => record.status == CheckinStatus.missed)
        .length;
  }

  /// Get check-in completion rate (0.0 to 1.0)
  double getCompletionRate({int days = 30}) {
    final history = getHistory(days: days);
    if (history.isEmpty) return 0.0;

    final completed = history
        .where((record) => record.status == CheckinStatus.completed)
        .length;

    return completed / history.length;
  }

  /// Delete a check-in record
  Future<void> deleteRecord(String dateKey) async {
    final box = _storage.checkinBox;
    await box.delete(dateKey);
  }

  /// Delete all check-in records
  Future<void> deleteAllRecords() async {
    final box = _storage.checkinBox;
    await box.clear();
  }

  /// Helper method to convert DateTime to key
  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Helper method to generate a unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
