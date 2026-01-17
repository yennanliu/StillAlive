// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckinStatusAdapter extends TypeAdapter<CheckinStatus> {
  @override
  final int typeId = 3;

  @override
  CheckinStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CheckinStatus.pending;
      case 1:
        return CheckinStatus.active;
      case 2:
        return CheckinStatus.completed;
      case 3:
        return CheckinStatus.missed;
      case 4:
        return CheckinStatus.paused;
      case 5:
        return CheckinStatus.manualAlert;
      default:
        return CheckinStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, CheckinStatus obj) {
    switch (obj) {
      case CheckinStatus.pending:
        writer.writeByte(0);
        break;
      case CheckinStatus.active:
        writer.writeByte(1);
        break;
      case CheckinStatus.completed:
        writer.writeByte(2);
        break;
      case CheckinStatus.missed:
        writer.writeByte(3);
        break;
      case CheckinStatus.paused:
        writer.writeByte(4);
        break;
      case CheckinStatus.manualAlert:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckinStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
