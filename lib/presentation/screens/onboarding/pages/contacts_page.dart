import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/emergency_contact.dart';
import '../../../../presentation/providers/providers.dart';
import '../widgets/contact_form.dart';

/// Contacts page - add initial emergency contacts
class ContactsPage extends ConsumerStatefulWidget {
  final VoidCallback onContinue;

  const ContactsPage({super.key, required this.onContinue});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  bool _showForm = false;

  void _addContact(String name, String phone, String? relationship) async {
    final contact = EmergencyContact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phoneNumber: phone,
      relationship: relationship,
      createdAt: DateTime.now(),
    );

    await ref.read(contactsNotifierProvider.notifier).addContact(contact);

    setState(() {
      _showForm = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added as emergency contact')),
      );
    }
  }

  void _removeContact(EmergencyContact contact) async {
    await ref.read(contactsNotifierProvider.notifier).deleteContact(contact.id);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${contact.name} removed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsNotifierProvider);
    final contactCount = contacts.length;
    final canContinue = contactCount >= 2;
    final canAddMore = contactCount < 5;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Emergency Contacts',
            style: AppTheme.headlineLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add 2-5 people to alert in an emergency:',
            style: AppTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: canContinue ? Colors.green[50] : Colors.orange[50],
              border: Border.all(
                color: canContinue ? Colors.green : Colors.orange,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  canContinue ? Icons.check_circle : Icons.info,
                  color: canContinue ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    canContinue
                        ? 'You have $contactCount contact${contactCount > 1 ? 's' : ''}'
                        : 'Add at least 2 contacts to continue',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_showForm) ...[
            Expanded(
              child: SingleChildScrollView(
                child: ContactForm(
                  onSave: _addContact,
                  onCancel: () {
                    setState(() {
                      _showForm = false;
                    });
                  },
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: contacts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No contacts added yet',
                            style: AppTheme.bodyLarge.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the button below to add your first contact',
                            style: AppTheme.bodySmall.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                contact.name[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(contact.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.phoneNumber),
                                if (contact.relationship != null)
                                  Text(
                                    contact.relationship!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeContact(contact),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            if (canAddMore)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showForm = true;
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Contact'),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: canContinue ? widget.onContinue : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
