// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 0;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      userName: fields[0] as String,
      checkinWindowStartMinutes: fields[1] as int,
      checkinWindowEndMinutes: fields[2] as int,
      isPaused: fields[3] as bool,
      pausedSince: fields[4] as DateTime?,
      notificationsEnabled: fields[5] as bool,
      reminderBeforeWindow: fields[6] as bool,
      reminderAtWindowStart: fields[7] as bool,
      reminderBeforeDeadline: fields[8] as bool,
      onboardingCompleted: fields[9] as bool,
      firstLaunchDate: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.checkinWindowStartMinutes)
      ..writeByte(2)
      ..write(obj.checkinWindowEndMinutes)
      ..writeByte(3)
      ..write(obj.isPaused)
      ..writeByte(4)
      ..write(obj.pausedSince)
      ..writeByte(5)
      ..write(obj.notificationsEnabled)
      ..writeByte(6)
      ..write(obj.reminderBeforeWindow)
      ..writeByte(7)
      ..write(obj.reminderAtWindowStart)
      ..writeByte(8)
      ..write(obj.reminderBeforeDeadline)
      ..writeByte(9)
      ..write(obj.onboardingCompleted)
      ..writeByte(10)
      ..write(obj.firstLaunchDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
