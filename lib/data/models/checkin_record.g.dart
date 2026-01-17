// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckinRecordAdapter extends TypeAdapter<CheckinRecord> {
  @override
  final int typeId = 2;

  @override
  CheckinRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckinRecord(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      status: fields[2] as CheckinStatus,
      checkinTimestamp: fields[3] as DateTime?,
      windowStartMinutes: fields[4] as int?,
      windowEndMinutes: fields[5] as int?,
      alertSent: fields[6] as bool,
      alertSentAt: fields[7] as DateTime?,
      alertedContacts: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckinRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.checkinTimestamp)
      ..writeByte(4)
      ..write(obj.windowStartMinutes)
      ..writeByte(5)
      ..write(obj.windowEndMinutes)
      ..writeByte(6)
      ..write(obj.alertSent)
      ..writeByte(7)
      ..write(obj.alertSentAt)
      ..writeByte(8)
      ..write(obj.alertedContacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckinRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
