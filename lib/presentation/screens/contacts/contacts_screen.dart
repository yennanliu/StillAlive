import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'add_contact_screen.dart';
import 'edit_contact_screen.dart';
import 'widgets/contact_list_item.dart';
import 'widgets/minimum_contacts_warning.dart';

/// Main contacts screen showing list of emergency contacts
class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsNotifierProvider);
    final contactCount = contacts.length;
    final hasMinimum = contactCount >= 2;
    final hasMaximum = contactCount >= 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Emergency Contacts'),
                  content: const Text(
                    'Add 2-5 people who will be contacted if you miss a check-in.\n\n'
                    'They will receive:\n'
                    '• SMS alerts\n'
                    '• Phone calls (if needed)\n\n'
                    'Keep their contact information up to date.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!hasMinimum)
            MinimumContactsWarning(currentCount: contactCount),
          if (contactCount > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: hasMinimum ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$contactCount of 5 contact${contactCount != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (hasMinimum)
                    Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
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
                          'No emergency contacts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add at least 2 contacts to enable alerts',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddContactScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Your First Contact'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ContactListItem(
                        contact: contact,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditContactScreen(
                                contact: contact,
                              ),
                            ),
                          );
                        },
                        onDelete: () async {
                          if (contactCount <= 2) {
                            // Show warning if deleting would go below minimum
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cannot Delete'),
                                content: const Text(
                                  'You must have at least 2 emergency contacts. '
                                  'Add another contact before deleting this one.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            await ref
                                .read(contactsNotifierProvider.notifier)
                                .deleteContact(contact.id);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${contact.name} deleted'),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: hasMaximum
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddContactScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
