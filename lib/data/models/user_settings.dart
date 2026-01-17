import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  String userName;

  @HiveField(1)
  int checkinWindowStartMinutes; // TimeOfDay stored as minutes from midnight (0-1439)

  @HiveField(2)
  int checkinWindowEndMinutes; // TimeOfDay stored as minutes from midnight (0-1439)

  @HiveField(3)
  bool isPaused;

  @HiveField(4)
  DateTime? pausedSince;

  @HiveField(5)
  bool notificationsEnabled;

  @HiveField(6)
  bool reminderBeforeWindow; // 30 min before

  @HiveField(7)
  bool reminderAtWindowStart;

  @HiveField(8)
  bool reminderBeforeDeadline; // 15 min before end

  @HiveField(9)
  bool onboardingCompleted;

  @HiveField(10)
  DateTime? firstLaunchDate;

  UserSettings({
    required this.userName,
    required this.checkinWindowStartMinutes,
    required this.checkinWindowEndMinutes,
    this.isPaused = false,
    this.pausedSince,
    this.notificationsEnabled = true,
    this.reminderBeforeWindow = true,
    this.reminderAtWindowStart = true,
    this.reminderBeforeDeadline = true,
    this.onboardingCompleted = false,
    this.firstLaunchDate,
  });

  // Helper getters to convert minutes to TimeOfDay
  TimeOfDay get checkinWindowStart {
    return TimeOfDay(
      hour: checkinWindowStartMinutes ~/ 60,
      minute: checkinWindowStartMinutes % 60,
    );
  }

  TimeOfDay get checkinWindowEnd {
    return TimeOfDay(
      hour: checkinWindowEndMinutes ~/ 60,
      minute: checkinWindowEndMinutes % 60,
    );
  }

  // Helper setters to convert TimeOfDay to minutes
  set checkinWindowStart(TimeOfDay time) {
    checkinWindowStartMinutes = time.hour * 60 + time.minute;
  }

  set checkinWindowEnd(TimeOfDay time) {
    checkinWindowEndMinutes = time.hour * 60 + time.minute;
  }

  // Helper method to create default settings
  factory UserSettings.defaults() {
    return UserSettings(
      userName: '',
      checkinWindowStartMinutes: 8 * 60, // 8:00 AM
      checkinWindowEndMinutes: 10 * 60, // 10:00 AM
      firstLaunchDate: DateTime.now(),
    );
  }
}
