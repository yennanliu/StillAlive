import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/emergency_contact.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../data/repositories/contacts_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/storage_service.dart';
import 'checkin_notifier.dart';
import 'settings_notifier.dart';
import 'contacts_notifier.dart';
import 'home_notifier.dart';
import 'history_notifier.dart';

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

// ==================== State Notifiers ====================

/// Provider for CheckinNotifier
final checkinNotifierProvider =
    StateNotifierProvider<CheckinNotifier, CheckinState>((ref) {
  final checkinRepo = ref.watch(checkinRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return CheckinNotifier(
    checkinRepository: checkinRepo,
    settingsRepository: settingsRepo,
  );
});

/// Provider for SettingsNotifier
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository: settingsRepo);
});

/// Provider for ContactsNotifier
final contactsNotifierProvider =
    StateNotifierProvider<ContactsNotifier, List<EmergencyContact>>((ref) {
  final contactsRepo = ref.watch(contactsRepositoryProvider);
  return ContactsNotifier(repository: contactsRepo);
});

/// Provider for HomeNotifier
final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, HomeScreenState>((ref) {
  final checkinRepo = ref.watch(checkinRepositoryProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final contactsRepo = ref.watch(contactsRepositoryProvider);
  return HomeNotifier(
    checkinRepository: checkinRepo,
    settingsRepository: settingsRepo,
    contactsRepository: contactsRepo,
  );
});

/// Provider for HistoryNotifier
final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  final checkinRepo = ref.watch(checkinRepositoryProvider);
  return HistoryNotifier(repository: checkinRepo);
});
