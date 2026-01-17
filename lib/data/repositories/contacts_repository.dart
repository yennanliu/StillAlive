import '../models/emergency_contact.dart';
import '../services/storage_service.dart';

/// Repository for managing emergency contacts in Hive
class ContactsRepository {
  final StorageService _storage;

  ContactsRepository({StorageService? storage})
      : _storage = storage ?? StorageService();

  /// Get all emergency contacts
  List<EmergencyContact> getAllContacts() {
    final box = _storage.contactsBox;
    return box.values.toList();
  }

  /// Get a specific contact by ID
  EmergencyContact? getContact(String id) {
    final box = _storage.contactsBox;
    return box.get(id);
  }

  /// Add a new contact
  Future<void> addContact(EmergencyContact contact) async {
    final box = _storage.contactsBox;
    await box.put(contact.id, contact);
  }

  /// Update an existing contact
  Future<void> updateContact(EmergencyContact contact) async {
    final box = _storage.contactsBox;
    if (box.containsKey(contact.id)) {
      await box.put(contact.id, contact);
    } else {
      throw Exception('Contact with ID ${contact.id} not found');
    }
  }

  /// Delete a contact by ID
  Future<void> deleteContact(String id) async {
    final box = _storage.contactsBox;
    await box.delete(id);
  }

  /// Get the count of contacts
  int getContactCount() {
    return _storage.contactsBox.length;
  }

  /// Check if minimum contacts requirement is met (2 contacts)
  bool hasMinimumContacts() {
    return getContactCount() >= 2;
  }

  /// Check if maximum contacts limit is reached (5 contacts)
  bool hasMaximumContacts() {
    return getContactCount() >= 5;
  }

  /// Verify a contact (mark as verified)
  Future<void> verifyContact(String id) async {
    final contact = getContact(id);
    if (contact != null) {
      contact.isVerified = true;
      await contact.save();
    }
  }

  /// Delete all contacts
  Future<void> deleteAllContacts() async {
    final box = _storage.contactsBox;
    await box.clear();
  }
}
