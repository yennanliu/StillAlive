import 'package:hive_flutter/hive_flutter.dart';
import '../models/checkin_record.dart';
import '../models/checkin_status.dart';
import '../models/emergency_contact.dart';
import '../models/user_settings.dart';

/// Service for initializing and managing Hive local storage
class StorageService {
  // Box names
  static const String settingsBoxName = 'settings_box';
  static const String contactsBoxName = 'contacts_box';
  static const String checkinBoxName = 'checkin_box';

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  bool _initialized = false;

  /// Initialize Hive and register all type adapters
  Future<void> init() async {
    if (_initialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register type adapters
    Hive.registerAdapter(CheckinStatusAdapter()); // Type ID: 3
    Hive.registerAdapter(UserSettingsAdapter()); // Type ID: 0
    Hive.registerAdapter(EmergencyContactAdapter()); // Type ID: 1
    Hive.registerAdapter(CheckinRecordAdapter()); // Type ID: 2

    // Open boxes
    await Hive.openBox<UserSettings>(settingsBoxName);
    await Hive.openBox<EmergencyContact>(contactsBoxName);
    await Hive.openBox<CheckinRecord>(checkinBoxName);

    _initialized = true;
  }

  /// Get the settings box
  Box<UserSettings> get settingsBox {
    _ensureInitialized();
    return Hive.box<UserSettings>(settingsBoxName);
  }

  /// Get the contacts box
  Box<EmergencyContact> get contactsBox {
    _ensureInitialized();
    return Hive.box<EmergencyContact>(contactsBoxName);
  }

  /// Get the checkin box
  Box<CheckinRecord> get checkinBox {
    _ensureInitialized();
    return Hive.box<CheckinRecord>(checkinBoxName);
  }

  /// Ensure storage is initialized
  void _ensureInitialized() {
    // Check if box is already open (for testing scenarios)
    if (Hive.isBoxOpen(settingsBoxName)) {
      _initialized = true;
      return;
    }

    if (!_initialized) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
  }

  /// Close all boxes (for cleanup)
  Future<void> close() async {
    if (!_initialized) return;

    await settingsBox.close();
    await contactsBox.close();
    await checkinBox.close();

    _initialized = false;
  }

  /// Clear all data (for testing or reset)
  Future<void> clearAll() async {
    _ensureInitialized();

    await settingsBox.clear();
    await contactsBox.clear();
    await checkinBox.clear();
  }
}
