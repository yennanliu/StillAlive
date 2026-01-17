import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'checkin_status.dart';

part 'checkin_record.g.dart';

@HiveType(typeId: 2)
class CheckinRecord extends HiveObject {
  @HiveField(0)
  String id; // UUID

  @HiveField(1)
  DateTime date; // Date only (normalized to midnight)

  @HiveField(2)
  CheckinStatus status;

  @HiveField(3)
  DateTime? checkinTimestamp; // When user checked in (if status=completed)

  @HiveField(4)
  int? windowStartMinutes; // Window start for this day (minutes from midnight)

  @HiveField(5)
  int? windowEndMinutes; // Window end for this day (minutes from midnight)

  @HiveField(6)
  bool alertSent; // True if emergency alert was triggered

  @HiveField(7)
  DateTime? alertSentAt; // When alert was sent

  @HiveField(8)
  List<String>? alertedContacts; // Contact IDs that were alerted

  CheckinRecord({
    required this.id,
    required this.date,
    required this.status,
    this.checkinTimestamp,
    this.windowStartMinutes,
    this.windowEndMinutes,
    this.alertSent = false,
    this.alertSentAt,
    this.alertedContacts,
  });

  // Helper getters to convert minutes to TimeOfDay
  TimeOfDay? get windowStart {
    if (windowStartMinutes == null) return null;
    return TimeOfDay(
      hour: windowStartMinutes! ~/ 60,
      minute: windowStartMinutes! % 60,
    );
  }

  TimeOfDay? get windowEnd {
    if (windowEndMinutes == null) return null;
    return TimeOfDay(
      hour: windowEndMinutes! ~/ 60,
      minute: windowEndMinutes! % 60,
    );
  }

  // Helper setters to convert TimeOfDay to minutes
  set windowStart(TimeOfDay? time) {
    windowStartMinutes = time != null ? time.hour * 60 + time.minute : null;
  }

  set windowEnd(TimeOfDay? time) {
    windowEndMinutes = time != null ? time.hour * 60 + time.minute : null;
  }

  // Helper method to normalize date to midnight
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Helper method to create a key for Hive storage (YYYY-MM-DD)
  String get dateKey {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Copy with method for updates
  CheckinRecord copyWith({
    String? id,
    DateTime? date,
    CheckinStatus? status,
    DateTime? checkinTimestamp,
    int? windowStartMinutes,
    int? windowEndMinutes,
    bool? alertSent,
    DateTime? alertSentAt,
    List<String>? alertedContacts,
  }) {
    return CheckinRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      checkinTimestamp: checkinTimestamp ?? this.checkinTimestamp,
      windowStartMinutes: windowStartMinutes ?? this.windowStartMinutes,
      windowEndMinutes: windowEndMinutes ?? this.windowEndMinutes,
      alertSent: alertSent ?? this.alertSent,
      alertSentAt: alertSentAt ?? this.alertSentAt,
      alertedContacts: alertedContacts ?? this.alertedContacts,
    );
  }
}
