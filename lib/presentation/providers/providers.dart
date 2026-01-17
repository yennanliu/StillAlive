import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/storage_service.dart';

/// Provider for StorageService (singleton)
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SettingsRepository(storage: storage);
});

/// Provider for ContactsRepository
final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ContactsRepository(storage: storage);
});

/// Provider for CheckinRepository
final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return CheckinRepository(storage: storage);
});
