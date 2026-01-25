import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/emergency_contact.dart';
import '../../data/repositories/contacts_repository.dart';

/// Notifier for managing emergency contacts
class ContactsNotifier extends StateNotifier<List<EmergencyContact>> {
  final ContactsRepository _repository;

  ContactsNotifier({required ContactsRepository repository})
    : _repository = repository,
      super(repository.getAllContacts());

  /// Add a new contact
  Future<void> addContact(EmergencyContact contact) async {
    await _repository.addContact(contact);
    state = _repository.getAllContacts();
  }

  /// Update an existing contact
  Future<void> updateContact(EmergencyContact contact) async {
    await _repository.updateContact(contact);
    state = _repository.getAllContacts();
  }

  /// Delete a contact
  Future<void> deleteContact(String id) async {
    await _repository.deleteContact(id);
    state = _repository.getAllContacts();
  }

  /// Verify a contact (mark as verified)
  Future<void> verifyContact(String id) async {
    await _repository.verifyContact(id);
    state = _repository.getAllContacts();
  }

  /// Check if minimum contacts requirement is met (2 contacts)
  bool hasMinimumContacts() {
    return _repository.hasMinimumContacts();
  }

  /// Check if maximum contacts limit is reached (5 contacts)
  bool hasMaximumContacts() {
    return _repository.hasMaximumContacts();
  }

  /// Get contact count
  int getContactCount() {
    return _repository.getContactCount();
  }

  /// Validate phone number (E.164 format)
  bool validatePhoneNumber(String phone) {
    // E.164 format: +[country code][number] (e.g., +12345678901)
    // Pattern: starts with +, followed by 1-3 digit country code, then 1-14 digits
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phone);
  }

  /// Validate contact name
  bool validateName(String name) {
    return name.trim().isNotEmpty && name.length <= 50;
  }

  /// Refresh contacts from repository
  void refresh() {
    state = _repository.getAllContacts();
  }
}
