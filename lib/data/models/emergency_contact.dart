import 'package:hive/hive.dart';

part 'emergency_contact.g.dart';

@HiveType(typeId: 1)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  String id; // UUID

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNumber; // E.164 format: +1234567890

  @HiveField(3)
  String? relationship; // Family, Friend, Neighbor, etc.

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isVerified; // Optional: if test SMS was sent

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.relationship,
    required this.createdAt,
    this.isVerified = false,
  });

  // Copy with method for updates
  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
