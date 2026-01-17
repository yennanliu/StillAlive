import 'package:hive/hive.dart';

part 'checkin_status.g.dart';

@HiveType(typeId: 3)
enum CheckinStatus {
  @HiveField(0)
  pending, // Before window opens

  @HiveField(1)
  active, // Window is open

  @HiveField(2)
  completed, // Successfully checked in

  @HiveField(3)
  missed, // Window closed without check-in

  @HiveField(4)
  paused, // App was paused on this day

  @HiveField(5)
  manualAlert, // User triggered emergency button
}
